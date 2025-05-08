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
        ScrollView([.vertical]) {
            Picker("Choose a gen", selection: $vm.selectedGen) {
                ForEach(PokemonGen.allCases, id: \.self) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.menu)
            .padding(.top)
            .onChange(of: vm.selectedGen) {
                Task { @MainActor in
                    await vm.loadAllPokemon(for: vm.selectedGen)
                }
            }

            ScrollView([.horizontal]) {
                LazyHGrid(rows: [GridItem()], spacing: 16) {
                    ForEach(filteredPokemonList) { pokemon in
                        NavigationLink(destination: PokemonDetailScreen(pokemon: pokemon)) {
                            PokemonPreviewView(pokemon: pokemon)
                        }
                        .buttonStyle(.plain)
                        .task {
                            await vm.loadPokemonDetails(for: pokemon)
                        }
                    }
                    .padding()
                }
            }
            .frame(height: 500)
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
