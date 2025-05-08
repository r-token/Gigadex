//
//  HomeScreen+ViewModel.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import SwiftUI

extension HomeScreen {
    @MainActor @Observable
    class ViewModel {
        var pokemonList = [PokemonInfo]()
        var isShowingErrorAlert = false
        var errorInfo = ""

        func loadAllPokemon(for gen: PokemonGen) async {
            do {
                pokemonList = try await API.fetchAllPokemon(for: gen)
            } catch {
                print("Error fetching pokemon for gen \(gen): \(error)")
                isShowingErrorAlert = true
                errorInfo = error.localizedDescription
            }
        }

        func loadPokemonDetails(for pokemon: PokemonInfo) async {
            do {
                guard let index = pokemonList.firstIndex(where: { $0.id == pokemon.id }) else {
                    print("Unknown pokemon")
                    return
                }
                // Don't hit the API again if we have already fetched details for this pokemon
                guard pokemonList[index].details == nil else { return }

                let details = try await API.fetchDetails(for: pokemon.id)

                if let imageUrlString = details.sprites.other?.officialArtwork?.frontDefault,
                   !imageUrlString.isEmpty {
                    print("Setting \(pokemon.name)'s image url to \(imageUrlString)")
                    pokemonList[index].imageUrl = URL(string: imageUrlString)!
                }
                pokemonList[index].details = details
            } catch {
                print("Error fetching pokemon info for \(pokemon.name): \(error)")
                isShowingErrorAlert = true
                errorInfo = error.localizedDescription
            }
        }
    }
}
