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
                            Text(condition)
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                                .frame(width: 70)
                        }
                    }
                    .padding(.horizontal, 5)
                }

                // Show the Pokémon
                VStack {
                    PokemonAsyncImage(url: evolution.imageUrl, size: 150)
                        .opacity(evolution.name == pokemon.name ? 1.0 : 0.7)

                    Text(evolution.name)
                        .font(.callout)
                        .fontWeight(evolution.name == pokemon.name ? .bold : .regular)
                }
                .padding(10)
                .background(evolution.name == pokemon.name ?
                            Color.blue.opacity(0.1) : Color.clear)
                .cornerRadius(10)
                .focusable(true)
            }
        }
        .padding()
    }
}

#Preview {
    LinearEvolutionChain(pokemon: Pokemon.sampleData, evolutionChainSequence: [PokemonEvolution.sampleData])
}
