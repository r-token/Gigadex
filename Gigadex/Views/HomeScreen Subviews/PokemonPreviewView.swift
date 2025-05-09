//
//  PokemonPreviewView.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import SwiftUI

struct PokemonPreviewView: View {
    let pokemon: Pokemon

    var body: some View {
        VStack {
            PokemonAsyncImage(url: pokemon.imageUrl, size: 300)

            Text(pokemon.name)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)

            HStack(spacing: 4) {
                Text("#\(pokemon.id)")
                    .foregroundStyle(.gray)
                    .fontWeight(.semibold)
                    .padding(.trailing)

                ForEach(pokemon.types) { type in
                    Image(systemName: type.imageName)
                        .foregroundStyle(type.color)
                }
            }
            .font(.caption)
        }
    }
}

#Preview {
    PokemonPreviewView(pokemon: Pokemon.sampleData)
}
