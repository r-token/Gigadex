//
//  HomeScreen+ViewModel.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import Combine
import SwiftUI

extension HomeScreen {
    @MainActor @Observable
    class ViewModel {
        var pokemonList = [Pokemon]()
        var selectedGen: PokemonGen = .gen1

        private var searchDebounceTimer: Timer?
        var debouncedSearchText = ""
        var searchText = "" {
            didSet {
                searchDebounceTimer?.invalidate()
                searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                    guard let self else { return }
                    Task { @MainActor in
                        withAnimation {
                            self.debouncedSearchText = self.searchText
                        }
                    }
                }
            }
        }

        var isShowingErrorAlert = false
        var errorInfo = ""

        private var cancellables = Set<AnyCancellable>()
        private let api: CoreAPI.Type

        init(api: CoreAPI.Type = API.Request.self) {
            self.api = api
        }

        // loadAllPokemon runs on app load - I have async/await & combine versions
        func loadAllPokemon(for gen: PokemonGen) async {
            do {
                pokemonList = try await api.fetchAllPokemon(for: gen)
            } catch {
                print("Error fetching pokemon for gen \(gen): \(error)")
                isShowingErrorAlert = true
                errorInfo = error.localizedDescription
            }
        }

        // Combine version of loadAllPokemon
        func loadAllPokemonWithCombine(for gen: PokemonGen) {
            api.pokemonPublisher(for: gen)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.handleError(error, for: "gen \(gen)")
                        }
                    },
                    receiveValue: { [weak self] pokemonList in
                        self?.pokemonList = pokemonList
                    }
                )
                .store(in: &cancellables)
        }

        // runs as pokemon scroll into view on the shelf
        func loadAllInfo(for pokemon: Pokemon) async {
            print("Loading all info for \(pokemon.name)")
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

        private func loadPokemonDetails(for pokemon: Pokemon) async {
            do {
                guard let index = pokemonList.firstIndex(where: { $0.id == pokemon.id }) else {
                    print("Unknown pokemon")
                    return
                }

                let details = try await api.fetchDetails(for: pokemon.id)

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

        private func loadPokemonSpecies(for pokemon: Pokemon) async {
            do {
                guard let index = pokemonList.firstIndex(where: { $0.id == pokemon.id }) else {
                    print("Unknown pokemon")
                    return
                }

                let species = try await api.fetchSpeciesInfo(for: pokemon.id)
                pokemonList[index].species = species
            } catch {
                print("Error fetching species info for \(pokemon.name): \(error)")
                isShowingErrorAlert = true
                errorInfo = error.localizedDescription
            }
        }

        private func loadEvolutionChain(for pokemon: Pokemon) async {
            do {
                guard let index = pokemonList.firstIndex(where: { $0.id == pokemon.id }) else {
                    print("Unknown pokemon")
                    return
                }

                // Make sure we have species data first
                guard let species = pokemonList[index].species else {
                    print("Cannot fetch evolution chain: No species data for \(pokemon.name)")
                    return
                }

                // Extract the evolution chain ID from the evolution_chain URL in the species data
                let evolutionChainUrl = species.evolutionChain.url
                let chainId = Utils.getId(from: evolutionChainUrl)

                let evolutionChain = try await api.fetchEvolutionChain(for: chainId)
                pokemonList[index].evolutionChain = evolutionChain
            } catch {
                print("Error fetching evolution chain for \(pokemon.name): \(error)")
                isShowingErrorAlert = true
                errorInfo = error.localizedDescription
            }
        }

        private func handleError(_ error: Error, for context: String) {
            print("Error fetching \(context): \(error)")
            isShowingErrorAlert = true
            errorInfo = error.localizedDescription
        }
    }
}
