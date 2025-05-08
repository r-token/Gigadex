//
//  API.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import Foundation

enum PokemonGen {
    case gen1, gen2, gen3, gen4, gen5, gen6, gen7, gen8, gen9
}

enum APIError: Error {
    case message(String)

    init(_ message: String) {
        self = .message(message)
    }
}

struct API {
    static func fetchAllPokemon(for gen: PokemonGen) async throws -> [PokemonInfo] {
        let baseUrl = "https://pokeapi.co/api/v2"
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw APIError("Invalid server URL: \(baseUrl)")
        }

        var limit: Int
        var offset: Int

        // TODO: Check if there's some math we can do here instead
        switch gen {
        case .gen1:
            limit = 151
            offset = 0
        case .gen2:
            limit = 100
            offset = 151
        case .gen3:
            limit = 135
            offset = 251
        case .gen4:
            limit = 107
            offset = 386
        case .gen5:
            limit = 156
            offset = 493
        case .gen6:
            limit = 72
            offset = 649
        case .gen7:
            limit = 88
            offset = 721
        case .gen8:
            limit = 96
            offset = 809
        case .gen9:
            limit = 120
            offset = 905
        }

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

        var pokemonInfoList: [PokemonInfo] = []
        for pokemon in pokemonSummaryWrapper.results {
            let id = getPokeId(from: pokemon.url)
            let pokemonInfo = PokemonInfo(id: id, name: pokemon.name)
            pokemonInfoList.append(pokemonInfo)
        }
        return pokemonInfoList
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
        print("Fetching details for pokemon \(pokemonId) with url \(url)")
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

    private static func getPokeId(from url: String) -> String {
        let cleanUrl = url.hasSuffix("/") ? String(url.dropLast()) : url
        let components = cleanUrl.components(separatedBy: "/")
        return components.last ?? ""
    }
}
