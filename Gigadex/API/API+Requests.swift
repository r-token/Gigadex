//
//  API+Requests.swift
//  Gigadex
//
//  Created by Ryan Token on 5/9/25.
//

import Foundation

extension API {
    struct Request {
        static func fetchAllPokemon(for gen: PokemonGen) async throws -> [Pokemon] {
            let genRanges: [PokemonGen: (start: Int, end: Int)] = [
                .gen1: (1, 151),
                .gen2: (152, 251),
                .gen3: (252, 386),
                .gen4: (387, 493),
                .gen5: (494, 649),
                .gen6: (650, 721),
                .gen7: (722, 809),
                .gen8: (810, 905),
                .gen9: (906, 1025)
            ]

            guard let range = genRanges[gen] else {
                throw APIError("Invalid generation: \(gen)")
            }

            let offset = range.start - 1
            let limit = range.end - range.start + 1

            let queryItems = [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]

            let wrapper: PokemonSummaryWrapper = try await fetch(endpoint: "/pokemon", queryItems: queryItems)

            return wrapper.results.map { pokemon in
                let id = Utils.getId(from: pokemon.url)
                return Pokemon(id: id, name: pokemon.name.capitalized)
            }
        }

        static func fetchDetails(for pokemonId: String) async throws -> PokemonDetails {
            return try await fetch(endpoint: "/pokemon/\(pokemonId)")
        }

        static func fetchSpeciesInfo(for pokemonId: String) async throws -> PokemonSpecies {
            return try await fetch(endpoint: "/pokemon-species/\(pokemonId)")
        }

        static func fetchEvolutionChain(for chainId: String) async throws -> EvolutionChain {
            return try await fetch(endpoint: "/evolution-chain/\(chainId)")
        }

        static func fetchMoveDetails(for move: String) async throws -> MoveDetail {
            return try await fetch(endpoint: "/move/\(move)")
        }
    }
}
