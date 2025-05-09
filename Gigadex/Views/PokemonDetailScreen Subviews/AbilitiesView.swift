//
//  AbilitiesView.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct AbilitiesView: View {
    let pokemon: Pokemon

    var backgroundColor: Color {
        pokemon.types.first?.color ?? .gray
    }

    var body: some View {
        HStack(spacing: 16) {
            ForEach(pokemon.abilities, id: \.ability.url) { ability in
                Text(cleanAbility(ability))
                    .fontWeight(.semibold)
                    .padding(2)
                    .padding(.horizontal)
                    .background(backgroundColor.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    func cleanAbility(_ ability: Ability) -> String {
        ability.ability.name.capitalized.replacingOccurrences(of: "-", with: " ")
    }
}

#Preview {
    AbilitiesView(pokemon: Pokemon.sampleData)
}
