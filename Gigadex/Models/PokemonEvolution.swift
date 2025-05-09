//
//  PokemonEvolution.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import Foundation

struct PokemonEvolution: Identifiable {
    let id = UUID()
    let name: String
    let imageUrl: URL?
    let evolutionLevel: Int // Position in the chain (0 = base, 1 = middle, 2 = final, etc.)
    let trigger: String? // How this evolution happens ("level-up", "trade", etc.)
    let triggerCondition: String? // Any condition needed ("min_level: 16", "item: water-stone", etc.)

    static let sampleData = PokemonEvolution(
        name: "Ditto",
        imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png"),
        evolutionLevel: 0,
        trigger: nil,
        triggerCondition: nil
    )
}
