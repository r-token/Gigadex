//
//  LinearEvolutionChain.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct LinearEvolutionChain: View {
    let pokemon: Pokemon
    let evolutionChainSequence: [PokemonEvolution]

    var body: some View {
        HStack {
            ForEach(0..<evolutionChainSequence.count, id: \.self) { index in
                let evolution = evolutionChainSequence[index]

                // For every Pokémon except the first one, show arrow before the Pokémon
                if index > 0 {
                    VStack {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.gray)
                            .font(.title3)

                        if let condition = evolution.triggerCondition {
                            Text(condition.replacingOccurrences(of: "-", with: " "))
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 5)
                }

                // Show the Pokémon
                VStack {
                    PokemonAsyncImage(url: evolution.imageUrl, size: 150, pokemonName: evolution.name)

                    Text(evolution.name)
                        .font(.callout)
                        .fontWeight(evolution.name == pokemon.name ? .bold : .regular)
                }
                .padding(10)
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    LinearEvolutionChain(pokemon: Pokemon.sampleData, evolutionChainSequence: [PokemonEvolution.sampleData])
}
