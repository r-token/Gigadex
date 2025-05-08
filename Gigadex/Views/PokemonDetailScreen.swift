//
//  PokemonDetailScreen.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct PokemonDetailScreen: View {
    let pokemon: Pokemon

    var body: some View {
        Text("Hello, \(pokemon.name)")
    }
}

#Preview {
    PokemonDetailScreen(pokemon: Pokemon.sampleData)
}
