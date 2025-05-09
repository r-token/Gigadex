//
//  BranchedEvolutionChain.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct BranchedEvolutionChain: View {
    let selectedPokemon: Pokemon
    let basePokemon: PokemonEvolution
    let evolutions: [PokemonEvolution]

    var body: some View {
        // Base Pokemon
        VStack {
            PokemonAsyncImage(url: basePokemon.imageUrl, size: 150, pokemonName: selectedPokemon.name)
                .padding(.bottom, 5)

            Text(basePokemon.name)
                .font(.callout)
                .fontWeight(basePokemon.name == selectedPokemon.name ? .bold : .regular)
        }
        .padding()

        Image(systemName: "arrow.down")
            .foregroundColor(.gray)
            .font(.title3)

        // All branching evolutions
        LazyHGrid(rows: [GridItem()], spacing: 20) {
            ForEach(evolutions) { evolution in
                VStack {
                    Group {
                        if let evoCondition = evolution.triggerCondition {
                            Text(evoCondition)
                        } else {
                            Text("Unknown")
                        }
                    }
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .frame(height: 40)
                    .padding(.horizontal, 5)

                    PokemonAsyncImage(url: evolution.imageUrl, size: 150, pokemonName: evolution.name)

                    Text(evolution.name)
                        .font(.caption)
                        .fontWeight(evolution.name == selectedPokemon.name ? .bold : .regular)
                }
                .padding()
                .cornerRadius(10)

            }
        }
        .padding()
        .focusable()
    }
}

#Preview {
    BranchedEvolutionChain(selectedPokemon: Pokemon.sampleData, basePokemon: PokemonEvolution.sampleData, evolutions: [])
}
