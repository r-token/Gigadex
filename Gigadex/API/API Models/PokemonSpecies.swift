//
//  PokemonSpecies.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import Foundation

struct PokemonSpecies: Codable {
    let baseHappiness: Int
    let captureRate: Int
    let color: NamedAPIResource
    let eggGroups: [NamedAPIResource]
    let evolutionChain: APIResource
    let evolvesFromSpecies: NamedAPIResource?
    let flavorTextEntries: [FlavorTextEntry]
    let formDescriptions: [FormDescription]
    let formsSwitchable: Bool
    let genderRate: Int
    let genera: [Genus]
    let order: Int
    let palParkEncounters: [PalParkEncounter]
    let pokedexNumbers: [PokedexNumber]
    let shape: NamedAPIResource
    let varieties: [Variety]

    enum CodingKeys: String, CodingKey {
        case baseHappiness = "base_happiness"
        case captureRate = "capture_rate"
        case color
        case eggGroups = "egg_groups"
        case evolutionChain = "evolution_chain"
        case evolvesFromSpecies = "evolves_from_species"
        case flavorTextEntries = "flavor_text_entries"
        case formDescriptions = "form_descriptions"
        case formsSwitchable = "forms_switchable"
        case genderRate = "gender_rate"
        case genera
        case order
        case palParkEncounters = "pal_park_encounters"
        case pokedexNumbers = "pokedex_numbers"
        case shape
        case varieties
    }
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

struct APIResource: Codable {
    let url: String
}

struct FlavorTextEntry: Codable {
    let flavorText: String
    let language: NamedAPIResource
    let version: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case version
    }
}

struct FormDescription: Codable {
    let description: String
    let language: NamedAPIResource
}

struct Genus: Codable {
    let genus: String
    let language: NamedAPIResource
}

struct PalParkEncounter: Codable {
    let area: NamedAPIResource
    let baseScore: Int
    let rate: Int

    enum CodingKeys: String, CodingKey {
        case area
        case baseScore = "base_score"
        case rate
    }
}

struct PokedexNumber: Codable {
    let entryNumber: Int
    let pokedex: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case entryNumber = "entry_number"
        case pokedex
    }
}

struct Variety: Codable {
    let isDefault: Bool
    let pokemon: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case pokemon
    }
}
