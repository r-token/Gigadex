//
//  API.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import Foundation

enum APIError: Error {
    case message(String)

    init(_ message: String) {
        self = .message(message)
    }
}

struct API {
    static func fetchAllPokemon(for gen: PokemonGen) async throws -> [Pokemon] {
        let baseUrl = "https://pokeapi.co/api/v2"
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw APIError("Invalid server URL: \(baseUrl)")
        }

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

        // Build the URL for the API request
        urlComponents.path.append("/pokemon")
        let queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            throw APIError("Invalid API endpoint: \(urlComponents)")
        }

        // Make the request
        print("Fetching all pokemon for gen \(gen) with urlString \(url)")
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError("API response was not an HTTP response")
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError("API request failed with status code: \(httpResponse.statusCode)")
        }
        if let contentType = httpResponse.value(forHTTPHeaderField: "content-type") {
            guard contentType.lowercased().contains("application/json") else {
                throw APIError("Unexpected content type: \(contentType)")
            }
        }

        // Decode the response into our API type
        let pokemonSummaryWrapper: PokemonSummaryWrapper
        do {
            pokemonSummaryWrapper = try JSONDecoder().decode(PokemonSummaryWrapper.self, from: data)
        } catch {
            print("Full error: \(error)")
            throw APIError("Unexpected response body, error: \(error.localizedDescription)")
        }

        var pokemonList: [Pokemon] = []
        for pokemon in pokemonSummaryWrapper.results {
            let id = Utils.getId(from: pokemon.url)
            let pokemon = Pokemon(id: id, name: pokemon.name.capitalized)
            pokemonList.append(pokemon)
        }
        return pokemonList
    }

    static func fetchDetails(for pokemonId: String) async throws -> PokemonDetails {
        let baseUrl = "https://pokeapi.co/api/v2"
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw APIError("Invalid server URL: \(baseUrl)")
        }

        // Build the URL for the API request
        urlComponents.path.append("/pokemon/\(pokemonId)")
        guard let url = urlComponents.url else {
            throw APIError("Invalid API endpoint: \(urlComponents)")
        }

        // Make the request
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError("API response was not an HTTP response")
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError("API request failed with status code: \(httpResponse.statusCode)")
        }
        if let contentType = httpResponse.value(forHTTPHeaderField: "content-type") {
            guard contentType.lowercased().contains("application/json") else {
                throw APIError("Unexpected content type: \(contentType)")
            }
        }

        // Decode the response into our API type & return it
        do {
            return try JSONDecoder().decode(PokemonDetails.self, from: data)
        } catch {
            throw APIError("Unexpected response body, error: \(error.localizedDescription)")
        }
    }

    static func fetchSpeciesInfo(for pokemonId: String) async throws -> PokemonSpecies {
        let baseUrl = "https://pokeapi.co/api/v2"
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw APIError("Invalid server URL: \(baseUrl)")
        }

        // Build the URL for the API request
        urlComponents.path.append("/pokemon-species/\(pokemonId)")
        guard let url = urlComponents.url else {
            throw APIError("Invalid API endpoint: \(urlComponents)")
        }

        // Make the request
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError("API response was not an HTTP response")
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError("API request failed with status code: \(httpResponse.statusCode)")
        }
        if let contentType = httpResponse.value(forHTTPHeaderField: "content-type") {
            guard contentType.lowercased().contains("application/json") else {
                throw APIError("Unexpected content type: \(contentType)")
            }
        }

        // Decode the response into our API type & return it
        do {
            return try JSONDecoder().decode(PokemonSpecies.self, from: data)
        } catch {
            throw APIError("Unexpected response body, error: \(error.localizedDescription)")
        }
    }

    static func fetchEvolutionChain(for chainId: String) async throws -> EvolutionChain {
        let baseUrl = "https://pokeapi.co/api/v2"
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw APIError("Invalid server URL: \(baseUrl)")
        }

        // Build the URL for the API request
        urlComponents.path.append("/evolution-chain/\(chainId)")
        guard let url = urlComponents.url else {
            throw APIError("Invalid API endpoint: \(urlComponents)")
        }

        // Make the request
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError("API response was not an HTTP response")
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError("API request failed with status code: \(httpResponse.statusCode)")
        }
        if let contentType = httpResponse.value(forHTTPHeaderField: "content-type") {
            guard contentType.lowercased().contains("application/json") else {
                throw APIError("Unexpected content type: \(contentType)")
            }
        }

        // Decode the response into our API type & return it
        do {
            return try JSONDecoder().decode(EvolutionChain.self, from: data)
        } catch {
            throw APIError("Unexpected response body, error: \(error.localizedDescription)")
        }
    }

    // move can be the moveId or the string name of the move
    static func fetchMoveDetails(for move: String) async throws -> MoveDetail {
        let baseUrl = "https://pokeapi.co/api/v2"
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw APIError("Invalid server URL: \(baseUrl)")
        }

        // Build the URL for the API request
        urlComponents.path.append("/move/\(move)")
        guard let url = urlComponents.url else {
            throw APIError("Invalid API endpoint: \(urlComponents)")
        }

        // Make the request
        print("Fetching move details for \(move) at url: \(url)")
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError("API response was not an HTTP response")
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError("API request failed with status code: \(httpResponse.statusCode)")
        }
        if let contentType = httpResponse.value(forHTTPHeaderField: "content-type") {
            guard contentType.lowercased().contains("application/json") else {
                throw APIError("Unexpected content type: \(contentType)")
            }
        }

        // Decode the response into our API type & return it
        do {
            return try JSONDecoder().decode(MoveDetail.self, from: data)
        } catch {
            throw APIError("Unexpected response body, error: \(error.localizedDescription)")
        }
    }
}
