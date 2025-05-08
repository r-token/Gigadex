//
//  HomeScreen.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import SwiftUI

struct HomeScreen: View {
    @State private var vm = ViewModel()

    var body: some View {
        ScrollView([.horizontal]) {
            LazyHGrid(rows: [GridItem()], spacing: 16) {
                ForEach(vm.pokemonList) { pokemon in
                    Button(action: { print("Tapped \(pokemon.name)") }) {
                        PokemonPreviewView(pokemon: pokemon)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .task {
                        await vm.loadPokemonDetails(for: pokemon)
                    }
                }
            }
            .padding()
        }
        .task {
            await vm.loadAllPokemon(for: .gen1)
        }
    }
}

#Preview {
    HomeScreen()
}
