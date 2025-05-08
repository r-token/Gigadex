//
//  Models.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import Foundation

struct PokemonInfo: Identifiable, Codable {
    let id: String // will be the unique identifier for the pokemon from the API
    let name: String
    var imageUrl: URL? = nil
    var details: PokemonDetails? = nil

    static let sampleData = PokemonInfo(
        id: "132",
        name: "ditto",
        imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png")!,
        details: nil
    )
}
