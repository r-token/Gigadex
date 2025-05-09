//
//  PokemonImage.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import SwiftUI

struct PokemonAsyncImage: View {
    let url: URL?
    let imageSize: CGFloat
    let pokemonName: String // for accessibility

    init(url: URL?, size: CGFloat = 100, pokemonName: String) {
        self.url = url
        self.imageSize = size
        self.pokemonName = pokemonName
    }

    @State private var retryCount = 0
    @State private var isRetrying = false

    var body: some View {
        AsyncImage(
            url: url,
            transaction: Transaction(animation: .easeInOut)
        ) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.gray.opacity(0.2)
                    ProgressView()
                        .accessibilityLabel("Loading Pokémon image")
                }
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .transition(.opacity)
                    .accessibilityLabel(pokemonName)

            case .failure:
                Group {
                    if isRetrying {
                        ProgressView()
                    } else {
                        VStack {
                            Image(systemName: "photo")
                                .font(.system(size: imageSize * 0.3))
                                .foregroundColor(.gray)

                            if retryCount < 3 {
                                Button("Retry") {
                                    retryLoad()
                                }
                                .font(.caption)
                                .padding(.top, 5)
                            }
                        }
                        .accessibilityLabel("Failed to load Pokémon image")
                    }
                }
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            @unknown default:
                Image(systemName: "questionmark")
                    .frame(width: imageSize, height: imageSize)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityLabel("Unknown image state")
            }
        }
    }

    private func retryLoad() {
        guard retryCount < 3, let imageUrl = url else { return }

        isRetrying = true
        retryCount += 1

        // Create a new URL request ignoring AsyncImage's cache
        var request = URLRequest(url: imageUrl)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        Task {
            try? await Task.sleep(for: .seconds(0.5))
            URLCache.shared.removeCachedResponse(for: request)

            // Toggle state to force a view refresh
            await MainActor.run {
                isRetrying = false
                let _ = URL(string: imageUrl.absoluteString + "?retry=\(retryCount)")
            }
        }
    }
}

#Preview {
    PokemonAsyncImage(
        url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png"),
        pokemonName: "Ditto"
    )
}
