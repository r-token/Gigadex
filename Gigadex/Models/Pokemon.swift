//
//  Models.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import Foundation

struct Pokemon: Identifiable {
    let id: String // will be the unique identifier for the pokemon from the API
    let name: String
    var imageUrl: URL? = nil
    var details: PokemonDetails? = nil
    var species: PokemonSpecies? = nil
    var evolutionChain: EvolutionChain? = nil
    var evolutionChainSequence: [PokemonEvolution] = []

    var types: [Type] {
        var tempTypes: [Type] = []
        let typeStrings = details?.types.map { $0.type.name } ?? []
        for typeString in typeStrings {
            tempTypes.append(Type(name: typeString.capitalized))
        }
        return tempTypes
    }

    var description: String {
        let descriptionWithNewLines = species?.flavorTextEntries.first(where: { $0.language.name == "en" })?.flavorText ?? "No description available"
        return descriptionWithNewLines.replacingOccurrences(of: "\n", with: " ")
    }

    // height is returned in decimeters
    // 1 decimeter = 0.32808399 feet
    var height: Double {
        guard let decimeters = details?.height else { return 0 }
        let feet = Double(decimeters) * 0.32808399
        return (feet * 10).rounded() / 10
    }
    var formattedHeight: String {
        return String(format: "%.1f", height)
    }

    // weight is returned in hectograms
    // 1 hectogram = 0.22046226 pounds
    var weight: Double {
        guard let hectograms = details?.weight else { return 0 }
        let pounds = Double(hectograms) * 0.22046226
        return (pounds * 10).rounded() / 10
    }
    var formattedWeight: String {
        return String(format: "%.1f", weight)
    }

    var abilities: [Ability] {
        details?.abilities ?? []
    }

    var stats: [Stat] {
        details?.stats ?? []
    }

    var learnedMoves: [Move] {
        details?.moves.filter { move in
            move.versionGroupDetails.contains { detail in
                detail.moveLearnMethod.name == "level-up"
            }
        }.sorted(by: { $0.versionGroupDetails.first?.levelLearnedAt ?? 0 < $1.versionGroupDetails.first?.levelLearnedAt ?? 0 }) ?? []
    }

    var evolutionPosition: Int {
        return evolutionChainSequence.firstIndex(where: { $0.name.lowercased() == name.lowercased() }) ?? 0
    }

    var previousEvolution: PokemonEvolution? {
        let position = evolutionPosition
        return position > 0 ? evolutionChainSequence[position - 1] : nil
    }

    var nextEvolution: PokemonEvolution? {
        let position = evolutionPosition
        return position < evolutionChainSequence.count - 1 ? evolutionChainSequence[position + 1] : nil
    }

    static let sampleData = Pokemon(
        id: "132",
        name: "ditto",
        imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png")!,
        details: nil
    )
}
