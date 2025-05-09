//
//  PokemonDetailScreen.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct PokemonDetailScreen: View {
    let pokemon: Pokemon

    @Environment(\.dismiss) private var dismiss
    @Environment(\.resetFocus) private var resetFocus
    @State private var scrollViewProxy: ScrollViewProxy?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                PokemonSummaryHeader(pokemon: pokemon)
                    .id("top")
                    .focusable()

                EvolutionChainView(pokemon: pokemon)

                HStack(alignment: .top) {
                    StatsView(pokemon: pokemon)
                        .frame(maxWidth: .infinity)
                    MovesView(pokemon: pokemon)
                        .frame(maxWidth: .infinity)
                }
            }
            .onAppear {
                scrollViewProxy = proxy
            }
        }
        .onExitCommand {
            withAnimation {
                scrollViewProxy?.scrollTo("top", anchor: .top)
            }
            dismiss()
        }
    }
}

#Preview {
    PokemonDetailScreen(pokemon: Pokemon.sampleData)
}
