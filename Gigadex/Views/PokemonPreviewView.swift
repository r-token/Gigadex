//
//  PokemonPreviewView.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import SwiftUI

struct PokemonPreviewView: View {
    let pokemon: PokemonInfo

    var body: some View {
        VStack {
            Text(pokemon.name.capitalized)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
            PokemonAsyncImage(url: pokemon.imageUrl, size: 300)
        }
    }
}

#Preview {
    PokemonPreviewView(pokemon: PokemonInfo.sampleData)
}
