//
//  PokemonShelf.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct PokemonShelf: View {
    @Binding var vm: HomeScreen.ViewModel

    var filteredPokemonList: [Pokemon] {
        vm.pokemonList.filter {
            vm.debouncedSearchText.isEmpty ||
            $0.name.localizedStandardContains(vm.debouncedSearchText)
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
        .accessibilityLabel("Pokémon collection")
        .accessibilityHint(
            filteredPokemonList.isEmpty ?
                "No Pokémon found. Try changing your search" :
                "Swipe left or right to browse. Showing \(filteredPokemonList.count) Pokémon"
        )
    }
}

#Preview {
    PokemonShelf(vm: .constant(HomeScreen.ViewModel()))
}
