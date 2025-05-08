//
//  HomeScreen.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import SwiftUI

struct HomeScreen: View {
    @State private var vm = ViewModel()

    var filteredPokemonList: [Pokemon] {
        vm.pokemonList.filter {
            vm.searchText.isEmpty ||
            $0.name.localizedStandardContains(vm.searchText)
        }
    }

    var body: some View {
        List {
            Picker("Choose a gen", selection: $vm.selectedGen) {
                ForEach(PokemonGen.allCases, id: \.self) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: vm.selectedGen) {
                Task { @MainActor in
                    await vm.loadAllPokemon(for: vm.selectedGen)
                }
            }

            LazyHGrid(rows: [GridItem()], spacing: 16) {
                ForEach(filteredPokemonList) { pokemon in
                    Button(action: { print("Tapped \(pokemon.name)") }) {
                        PokemonPreviewView(pokemon: pokemon)
                    }
                    .buttonStyle(.plain)
                    .task {
                        await vm.loadPokemonDetails(for: pokemon)
                    }
                }
            }
            .padding()
        }
        .searchable(text: $vm.searchText)
        .task {
            await vm.loadAllPokemon(for: vm.selectedGen)
        }
    }
}

#Preview {
    HomeScreen()
}
