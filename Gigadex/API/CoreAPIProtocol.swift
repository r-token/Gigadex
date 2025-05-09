//
//  CoreAPIProtocol.swift
//  Gigadex
//
//  Created by Ryan Token on 5/9/25.
//

import Combine
import Foundation

protocol CoreAPI {
    // Async methods
    static func fetchAllPokemon(for gen: PokemonGen) async throws -> [Pokemon]
    static func fetchDetails(for pokemonId: String) async throws -> PokemonDetails
    static func fetchSpeciesInfo(for pokemonId: String) async throws -> PokemonSpecies
    static func fetchEvolutionChain(for chainId: String) async throws -> EvolutionChain
    static func fetchMoveDetails(for move: String) async throws -> MoveDetail

    // Combine methods
    static func pokemonPublisher(for gen: PokemonGen) -> AnyPublisher<[Pokemon], Error>
}
