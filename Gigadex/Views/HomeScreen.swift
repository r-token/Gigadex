//
//  HomeScreen.swift
//  Gigadex
//
//  Created by Ryan Token on 5/7/25.
//

import SwiftUI

struct HomeScreen: View {
    @State var vm = ViewModel()

    var body: some View {
        ScrollView {
            GenPicker(vm: $vm)
            PokemonShelf(vm: $vm)
        }
        .searchable(text: $vm.searchText)
        .task {
            // await vm.loadAllPokemon(for: vm.selectedGen) // async/await
            vm.loadAllPokemonWithCombine(for: vm.selectedGen) // combine
        }

        .alert(isPresented: $vm.isShowingErrorAlert) {
            Alert(
                title: Text("Error Loading Pokémon"),
                message: Text("Please try again later."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    HomeScreen()
}
