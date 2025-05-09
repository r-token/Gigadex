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
        var pokemonList = [Pokemon]()
        var searchText = ""
        var selectedGen: PokemonGen = .gen1

        var isShowingErrorAlert = false
        var errorInfo = ""

        func loadAllPokemon(for gen: PokemonGen) async {
            do {
                pokemonList = try await API.Request.fetchAllPokemon(for: gen)
            } catch {
                print("Error fetching pokemon for gen \(gen): \(error)")
                isShowingErrorAlert = true
                errorInfo = error.localizedDescription
            }
        }

        func loadAllInfo(for pokemon: Pokemon) async {
            await withTaskGroup { group in
                group.addTask {
                    await self.loadPokemonDetails(for: pokemon)
                }
                group.addTask {
                    await self.loadPokemonSpecies(for: pokemon)
                    await self.loadEvolutionChain(for: pokemon)
                }
            }
        }

        func loadPokemonDetails(for pokemon: Pokemon) async {
            do {
                guard let index = pokemonList.firstIndex(where: { $0.id == pokemon.id }) else {
                    print("Unknown pokemon")
                    return
                }
                // Don't hit the API again if we have already fetched details for this pokemon
                // guard pokemonList[index].details == nil else { return }

                let details = try await API.Request.fetchDetails(for: pokemon.id)

                if let imageUrlString = details.sprites.other?.officialArtwork?.frontDefault,
                   !imageUrlString.isEmpty {
                    pokemonList[index].imageUrl = URL(string: imageUrlString)!
                }
                pokemonList[index].details = details
            } catch {
                print("Error fetching details for \(pokemon.name): \(error)")
                isShowingErrorAlert = true
                errorInfo = error.localizedDescription
            }
        }

        func loadPokemonSpecies(for pokemon: Pokemon) async {
            do {
                guard let index = pokemonList.firstIndex(where: { $0.id == pokemon.id }) else {
                    print("Unknown pokemon")
                    return
                }
                // Don't hit the API again if we have already fetched species info for this pokemon
                // guard pokemonList[index].species == nil else { return }

                let species = try await API.Request.fetchSpeciesInfo(for: pokemon.id)
                pokemonList[index].species = species
            } catch {
                print("Error fetching species info for \(pokemon.name): \(error)")
                isShowingErrorAlert = true
                errorInfo = error.localizedDescription
            }
        }

        func loadEvolutionChain(for pokemon: Pokemon) async {
            do {
                guard let index = pokemonList.firstIndex(where: { $0.id == pokemon.id }) else {
                    print("Unknown pokemon")
                    return
                }

                // Don't hit the API again if we have already fetched the evolution chain for this pokemon
                // guard pokemonList[index].evolutionChain == nil else { return }

                // Make sure we have species data first
                guard let species = pokemonList[index].species else {
                    print("Cannot fetch evolution chain: No species data for \(pokemon.name)")
                    return
                }

                // Extract the evolution chain ID from the evolution_chain URL in the species data
                let evolutionChainUrl = species.evolutionChain.url
                let chainId = Utils.getId(from: evolutionChainUrl)

                let evolutionChain = try await API.Request.fetchEvolutionChain(for: chainId)
                pokemonList[index].evolutionChain = evolutionChain
            } catch {
                print("Error fetching evolution chain for \(pokemon.name): \(error)")
                isShowingErrorAlert = true
                errorInfo = error.localizedDescription
            }
        }
    }
}
