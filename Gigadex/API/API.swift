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
    private static let baseUrl = "https://pokeapi.co/api/v2"

    static func fetch<T: Decodable>(endpoint: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        // Build URL
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw APIError("Invalid server URL: \(baseUrl)")
        }

        urlComponents.path.append(endpoint)
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw APIError("Invalid API endpoint: \(urlComponents)")
        }

        // Make request
        let urlRequest = URLRequest(url: url)
        print("Fetching from: \(url)")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        // Validate response
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

        // Decode response
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw APIError("Failed to decode response: \(error.localizedDescription)")
        }
    }
}
