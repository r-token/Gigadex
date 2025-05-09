//
//  PokemonShelf.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct PokemonShelf: View {
    @Binding var vm: HomeScreen.ViewModel
    @State private var loadedPokemonIds = Set<String>()

    var filteredPokemonList: [Pokemon] {
        vm.pokemonList.filter {
            vm.searchText.isEmpty ||
            $0.name.localizedStandardContains(vm.searchText)
        }
    }

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem()], spacing: 0) {
                ForEach(filteredPokemonList) { pokemon in
                    NavigationLink(destination: PokemonDetailScreen(pokemon: pokemon)) {
                        PokemonPreviewView(pokemon: pokemon)
                    }
                    .buttonStyle(.plain)
                    .task {
                        await vm.loadAllInfo(for: pokemon)
                    }
                }
                .padding()
            }
        }
        .frame(height: 500)
    }
}

#Preview {
    PokemonShelf(vm: .constant(HomeScreen.ViewModel()))
}
