//
//  PokemonSummaryHeader.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct PokemonSummaryHeader: View {
    let pokemon: Pokemon

    var body: some View {
        HStack {
            PokemonAsyncImage(url: pokemon.imageUrl, size: 500, pokemonName: pokemon.name)

            Spacer()

            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(pokemon.name)
                            .font(.title)

                        Text("Pokédex #\(pokemon.id)")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }

                    Spacer()

                    ForEach(pokemon.types) { type in
                        VStack(spacing: 8) {
                            Image(systemName: type.imageName)
                                .font(.title2)
                                .foregroundStyle(type.color)

                            Text(type.name)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        .typeIconAccessibility(for: type)
                    }
                }

                Text(pokemon.description)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)

                VStack(alignment: .leading) {
                    Text("Height: \(pokemon.formattedHeight) feet")
                    Text("Weight: \(pokemon.formattedWeight) lbs")
                }

                HStack(spacing: 16) {
                    Text("Abilities:")
                        .fontWeight(.semibold)

                    AbilitiesView(pokemon: pokemon)
                }

                Spacer()
            }
            .padding(.top)
        }
        .focusable()
    }
}

#Preview {
    PokemonSummaryHeader(pokemon: Pokemon.sampleData)
}
