//
//  API+Requests.swift
//  Gigadex
//
//  Created by Ryan Token on 5/9/25.
//

import Foundation
import Combine

extension API {
    struct Request {
        // MARK: ASYNC/AWAIT METHODS
        static func fetchAllPokemon(for gen: PokemonGen) async throws -> [Pokemon] {
            let queryItems = try queryItemsForGeneration(gen)
            let wrapper: PokemonSummaryWrapper = try await API.fetch(endpoint: "/pokemon", queryItems: queryItems)

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

        // MARK: COMBINE METHODS
        static func pokemonPublisher(for gen: PokemonGen) -> AnyPublisher<[Pokemon], Error> {
            do {
                let queryItems = try queryItemsForGeneration(gen)

                return API.fetchPublisher(endpoint: "/pokemon", queryItems: queryItems)
                    .map { (wrapper: PokemonSummaryWrapper) -> [Pokemon] in
                        wrapper.results.map { pokemon in
                            let id = Utils.getId(from: pokemon.url)
                            return Pokemon(id: id, name: pokemon.name.capitalized)
                        }
                    }
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }

        // MARK: HELPERS
        private static let genRanges: [PokemonGen: (start: Int, end: Int)] = [
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

        private static func queryItemsForGeneration(_ gen: PokemonGen) throws -> [URLQueryItem] {
            guard let range = genRanges[gen] else {
                throw APIError("Invalid generation: \(gen)")
            }

            let offset = range.start - 1
            let limit = range.end - range.start + 1

            return [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
        }
    }
}
