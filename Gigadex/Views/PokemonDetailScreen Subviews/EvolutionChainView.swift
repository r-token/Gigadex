//
//  EvolutionChainView.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct EvolutionChainView: View {
    let pokemon: Pokemon

    @State private var evolutionChainSequence: [PokemonEvolution] = []
    @State private var isProcessingEvolution = false
    @State private var directEvolutions: [String: [PokemonEvolution]] = [:]

    var body: some View {
        VStack {
            if !evolutionChainSequence.isEmpty {
                VStack(alignment: .center) {
                    // Special handling for branched evolutions like Eevee
                    if let basePokemon = evolutionChainSequence.first,
                       let evolutions = directEvolutions[basePokemon.name.lowercased()],
                       evolutions.count > 1 {
                        BranchedEvolutionChain(selectedPokemon: pokemon, basePokemon: basePokemon, evolutions: evolutions)
                    } else {
                        if evolutionChainSequence.count > 1 {
                            LinearEvolutionChain(pokemon: pokemon, evolutionChainSequence: evolutionChainSequence)
                        }
                    }
                }
                .padding(.vertical)
            } else if isProcessingEvolution {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear {
            processEvolutionChain()
        }
    }

    @MainActor
    private func processEvolutionChain() {
        // Skip if we already have evolution data or if we're already processing
        if !evolutionChainSequence.isEmpty || isProcessingEvolution {
            return
        }

        // Skip if we don't have evolution chain data
        guard let evolutionChain = pokemon.evolutionChain else {
            return
        }

        isProcessingEvolution = true

        var sequence: [PokemonEvolution] = []
        // Dictionary to store direct evolutions for each species
        var directEvolutions: [String: [PokemonEvolution]] = [:]

        // Recursive function to traverse the evolution chain
        func traverseChain(_ chainLink: ChainLink, level: Int = 0, trigger: String? = nil, condition: String? = nil) {
            let speciesName = chainLink.species.name.lowercased()

            // Extract image URL from the chain's URL structure
            let imageUrlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(Utils.getId(from: chainLink.species.url)).png"
            let imageUrl = URL(string: imageUrlString)

            let evolution = PokemonEvolution(
                name: speciesName.capitalized,
                imageUrl: imageUrl,
                evolutionLevel: level,
                trigger: trigger,
                triggerCondition: condition
            )
            sequence.append(evolution)

            // Create a list of direct evolutions
            if chainLink.evolvesTo.count > 0 {
                var evolutions: [PokemonEvolution] = []

                for nextLink in chainLink.evolvesTo {
                    let nextSpeciesName = nextLink.species.name.lowercased()
                    let nextImageUrlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(Utils.getId(from: nextLink.species.url)).png"
                    let nextImageUrl = URL(string: nextImageUrlString)

                    // Extract trigger and condition information
                    let details = nextLink.evolutionDetails.first
                    let evolutionTrigger = details?.trigger.name

                    var evolutionCondition: String? = nil
                    if let minLevel = details?.minLevel {
                        evolutionCondition = "Level \(minLevel)"
                    } else if let item = details?.item?.name {
                        evolutionCondition = item.capitalized
                    } else if details?.heldItem != nil {
                        evolutionCondition = "Trade while holding item"
                    } else if let timeOfDay = details?.timeOfDay, !timeOfDay.isEmpty {
                        evolutionCondition = "Level up during \(timeOfDay)"
                    }

                    let directEvolution = PokemonEvolution(
                        name: nextSpeciesName.capitalized,
                        imageUrl: nextImageUrl,
                        evolutionLevel: level + 1,
                        trigger: evolutionTrigger,
                        triggerCondition: evolutionCondition?.replacingOccurrences(of: "-", with: " ")
                    )

                    evolutions.append(directEvolution)

                    // Continue building the linear chain
                    traverseChain(nextLink, level: level + 1, trigger: evolutionTrigger, condition: evolutionCondition)
                }

                directEvolutions[speciesName] = evolutions
            }
        }

        traverseChain(evolutionChain.chain)

        evolutionChainSequence = sequence
        self.directEvolutions = directEvolutions
        isProcessingEvolution = false
    }
}

#Preview {
    EvolutionChainView(pokemon: Pokemon.sampleData)
}
