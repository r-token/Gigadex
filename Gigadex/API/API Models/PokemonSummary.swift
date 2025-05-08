//
//  PokemonSummary.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import Foundation

struct PokemonSummaryWrapper: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonSummary]
}

struct PokemonSummary: Codable {
    let name: String
    let url: String
}
