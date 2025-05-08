//
//  Models.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import Foundation

struct Pokemon: Identifiable, Codable {
    let id: String // will be the unique identifier for the pokemon from the API
    let name: String
    var imageUrl: URL? = nil
    var details: PokemonDetails? = nil

    var types: [Type] {
        var tempTypes: [Type] = []
        let typeStrings = details?.types.map { $0.type.name } ?? []
        for typeString in typeStrings {
            tempTypes.append(Type(name: typeString))
        }
        return tempTypes
    }

    static let sampleData = Pokemon(
        id: "132",
        name: "ditto",
        imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png")!,
        details: nil
    )
}
