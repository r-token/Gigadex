//
//  MoveDetail.swift
//  Gigadex
//
//  Created by Ryan Token on 5/9/25.
//

import Foundation

struct MoveDetail: Codable {
    let id: Int
    let name: String
    let accuracy: Int?
    let effectChance: Int?
    let pp: Int?
    let priority: Int
    let power: Int?
    let contestCombos: ContestCombos?
    let contestEffect: APIResource?
    let contestType: NamedAPIResource?
    let damageClass: NamedAPIResource
    let effectChanges: [EffectChange]
    let effectEntries: [EffectEntry]
    let flavorTextEntries: [MoveFlavorTextEntry]
    let generation: NamedAPIResource
    let learnedByPokemon: [NamedAPIResource]
    let machines: [MachineVersionDetail]
    let meta: MoveMetaData?
    let names: [Name]
    let pastValues: [PastMoveValue]
    let statChanges: [StatChange]
    let superContestEffect: APIResource?
    let target: NamedAPIResource
    let type: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case id, name, accuracy, pp, priority, power
        case effectChance = "effect_chance"
        case contestCombos = "contest_combos"
        case contestEffect = "contest_effect"
        case contestType = "contest_type"
        case damageClass = "damage_class"
        case effectChanges = "effect_changes"
        case effectEntries = "effect_entries"
        case flavorTextEntries = "flavor_text_entries"
        case generation
        case learnedByPokemon = "learned_by_pokemon"
        case machines
        case meta
        case names
        case pastValues = "past_values"
        case statChanges = "stat_changes"
        case superContestEffect = "super_contest_effect"
        case target
        case type
    }

    static let sampleData = MoveDetail(
        id: 132,
        name: "test-move",
        accuracy: nil,
        effectChance: nil,
        pp: nil,
        priority: 2,
        power: nil,
        contestCombos: nil,
        contestEffect: nil,
        contestType: nil,
        damageClass: NamedAPIResource(name: "", url: ""),
        effectChanges: [],
        effectEntries: [],
        flavorTextEntries: [],
        generation: NamedAPIResource(name: "", url: ""),
        learnedByPokemon: [],
        machines: [],
        meta: nil,
        names: [],
        pastValues: [],
        statChanges: [],
        superContestEffect: nil,
        target: NamedAPIResource(name: "", url: ""),
        type: NamedAPIResource(name: "", url: "")
    )
}

struct ContestCombos: Codable {
    let normal: ContestComboDetail?
    let `super`: ContestComboDetail?
}

struct ContestComboDetail: Codable {
    let useBefore: [NamedAPIResource]?
    let useAfter: [NamedAPIResource]?

    enum CodingKeys: String, CodingKey {
        case useBefore = "use_before"
        case useAfter = "use_after"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let useBefore = try? container.decode([NamedAPIResource].self, forKey: .useBefore) {
            self.useBefore = useBefore
        } else {
            self.useBefore = nil
        }

        if let useAfter = try? container.decode([NamedAPIResource].self, forKey: .useAfter) {
            self.useAfter = useAfter
        } else {
            self.useAfter = nil
        }
    }
}

struct EffectChange: Codable {
    let effectEntries: [EffectEntry]
    let versionGroup: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries"
        case versionGroup = "version_group"
    }
}

struct EffectEntry: Codable {
    let effect: String
    let language: NamedAPIResource
    let shortEffect: String?

    enum CodingKeys: String, CodingKey {
        case effect, language
        case shortEffect = "short_effect"
    }
}

struct MoveFlavorTextEntry: Codable {
    let flavorText: String
    let language: NamedAPIResource
    let versionGroup: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case versionGroup = "version_group"
    }
}

struct MachineVersionDetail: Codable {
    let machine: APIResource
    let versionGroup: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case machine
        case versionGroup = "version_group"
    }
}

struct MoveMetaData: Codable {
    let ailment: NamedAPIResource
    let ailmentChance: Int
    let category: NamedAPIResource
    let critRate: Int
    let drain: Int
    let flinchChance: Int
    let healing: Int
    let maxHits: Int?
    let maxTurns: Int?
    let minHits: Int?
    let minTurns: Int?
    let statChance: Int

    enum CodingKeys: String, CodingKey {
        case ailment
        case ailmentChance = "ailment_chance"
        case category
        case critRate = "crit_rate"
        case drain
        case flinchChance = "flinch_chance"
        case healing
        case maxHits = "max_hits"
        case maxTurns = "max_turns"
        case minHits = "min_hits"
        case minTurns = "min_turns"
        case statChance = "stat_chance"
    }
}

struct Name: Codable {
    let name: String
    let language: NamedAPIResource
}

struct PastMoveValue: Codable {
    let accuracy: Int?
    let effectChance: Int?
    let power: Int?
    let pp: Int?
    let effectEntries: [EffectEntry]?
    let type: NamedAPIResource?
    let versionGroup: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case accuracy
        case effectChance = "effect_chance"
        case power, pp
        case effectEntries = "effect_entries"
        case type
        case versionGroup = "version_group"
    }
}

struct StatChange: Codable {
    let change: Int
    let stat: NamedAPIResource
}
