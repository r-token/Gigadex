//
//  PokemonSummaryHeader.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct PokemonSummaryHeader: View {
    let pokemon: Pokemon

    // height is returned in decimeters
    // 1 decimeter = 0.32808399 feet
    var formattedHeight: String {
        guard let decimeters = pokemon.details?.height else { return "Unknown" }
        let feet = Double(decimeters) * 0.32808399
        let roundedFeet = (feet * 10).rounded() / 10
        return String(format: "%.1f", roundedFeet)
    }

    // weight is returned in hectograms
    // 1 hectogram = 0.22046226 pounds
    var formattedWeight: String {
        guard let hectograms = pokemon.details?.weight else { return "Unknown" }
        let pounds = Double(hectograms) * 0.22046226
        let roundedPounds = (pounds * 10).rounded() / 10
        return String(format: "%.1f", roundedPounds)
    }

    var body: some View {
        HStack {
            PokemonAsyncImage(url: pokemon.imageUrl, size: 500)

            Spacer()

            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(pokemon.name)
                            .font(.title)

                        Text("Pokédex Number \(pokemon.id)")
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
                    }
                }

                Text(pokemon.description)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)

                VStack(alignment: .leading) {
                    Text("Height: \(formattedHeight) feet")
                    Text("Weight: \(formattedWeight) lbs")
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
