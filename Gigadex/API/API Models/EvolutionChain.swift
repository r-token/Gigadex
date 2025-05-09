//
//  EvolutionChain.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import Foundation

struct EvolutionChain: Codable {
    let id: Int
    let babyTriggerItem: ItemReference?
    let chain: ChainLink

    var baseSpeciesId: String? {
        let url = chain.species.url
        return Utils.getId(from: url)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case babyTriggerItem = "baby_trigger_item"
        case chain
    }
}

struct ChainLink: Codable {
    let isBaby: Bool
    let species: NamedAPIResource
    let evolutionDetails: [EvolutionDetail]
    let evolvesTo: [ChainLink]

    enum CodingKeys: String, CodingKey {
        case isBaby = "is_baby"
        case species
        case evolutionDetails = "evolution_details"
        case evolvesTo = "evolves_to"
    }
}

struct EvolutionDetail: Codable {
    let item: ItemReference?
    let trigger: NamedAPIResource
    let gender: Int?
    let heldItem: ItemReference?
    let knownMove: MoveReference?
    let knownMoveType: TypeReference?
    let location: LocationReference?
    let minLevel: Int?
    let minHappiness: Int?
    let minBeauty: Int?
    let minAffection: Int?
    let needsOverworldRain: Bool
    let partySpecies: SpeciesReference?
    let partyType: TypeReference?
    let relativePhysicalStats: Int?
    let timeOfDay: String
    let tradeSpecies: SpeciesReference?
    let turnUpsideDown: Bool

    enum CodingKeys: String, CodingKey {
        case item
        case trigger
        case gender
        case heldItem = "held_item"
        case knownMove = "known_move"
        case knownMoveType = "known_move_type"
        case location
        case minLevel = "min_level"
        case minHappiness = "min_happiness"
        case minBeauty = "min_beauty"
        case minAffection = "min_affection"
        case needsOverworldRain = "needs_overworld_rain"
        case partySpecies = "party_species"
        case partyType = "party_type"
        case relativePhysicalStats = "relative_physical_stats"
        case timeOfDay = "time_of_day"
        case tradeSpecies = "trade_species"
        case turnUpsideDown = "turn_upside_down"
    }
}

// Type aliases for semantic meaning
typealias ItemReference = NamedAPIResource
typealias MoveReference = NamedAPIResource
typealias TypeReference = NamedAPIResource
typealias LocationReference = NamedAPIResource
typealias SpeciesReference = NamedAPIResource
