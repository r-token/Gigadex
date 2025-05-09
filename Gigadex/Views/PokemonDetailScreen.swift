//
//  PokemonDetailScreen.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct PokemonDetailScreen: View {
    let pokemon: Pokemon
    
    var body: some View {
        ScrollView {
            PokemonSummaryHeader(pokemon: pokemon)
            EvolutionChainView(pokemon: pokemon)
            HStack(alignment: .top) {
                StatsView(pokemon: pokemon)
                    .frame(maxWidth: .infinity)
                MovesView(pokemon: pokemon)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    PokemonDetailScreen(pokemon: Pokemon.sampleData)
}
