//
//  PokemonDetails.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import Foundation

struct PokemonDetails: Codable {
    let id: Int
    let name: String
    let baseExperience: Int
    let height: Int
    let weight: Int
    let sprites: Sprites
    let stats: [Stat]
    let types: [TypeElement]
    let abilities: [Ability]
    let moves: [Move]
    let species: Species
    let order: Int
    let isDefault: Bool
    let formOrder: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, height, weight, sprites, stats, types, abilities, moves, species, order
        case baseExperience = "base_experience"
        case isDefault = "is_default"
        case formOrder = "form_order"
    }
}

struct Ability: Codable {
    let ability: Species
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability, slot
        case isHidden = "is_hidden"
    }
}

struct Species: Codable {
    let name: String
    let url: String
}

struct Move: Codable {
    let move: Species
    let versionGroupDetails: [VersionGroupDetail]

    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

struct VersionGroupDetail: Codable {
    let levelLearnedAt: Int
    let moveLearnMethod: Species
    let versionGroup: Species

    enum CodingKeys: String, CodingKey {
        case versionGroup = "version_group"
        case moveLearnMethod = "move_learn_method"
        case levelLearnedAt = "level_learned_at"
    }
}

struct Sprites: Codable {
    let frontDefault: String
    let frontShiny: String?
    let frontFemale: String?
    let frontShinyFemale: String?
    let backDefault: String?
    let backShiny: String?
    let backFemale: String?
    let backShinyFemale: String?
    let other: Other?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case frontFemale = "front_female"
        case frontShinyFemale = "front_shiny_female"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case backFemale = "back_female"
        case backShinyFemale = "back_shiny_female"
        case other
    }
}

struct Other: Codable {
    let officialArtwork: OfficialArtwork?
    let dreamWorld: DreamWorld?
    let home: Home?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
        case dreamWorld = "dream_world"
        case home
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String
    let frontShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct DreamWorld: Codable {
    let frontDefault: String?
    let frontFemale: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
    }
}

struct Home: Codable {
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
}

struct Stat: Codable {
    let baseStat: Int
    let effort: Int
    let stat: Species

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

struct TypeElement: Codable {
    let slot: Int
    let type: Species
}
