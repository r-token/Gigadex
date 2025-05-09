//
//  GenPicker.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct GenPicker: View {
    @Binding var vm: HomeScreen.ViewModel

    var body: some View {
        Picker("Choose a gen", selection: $vm.selectedGen) {
            ForEach(PokemonGen.allCases, id: \.self) {
                Text($0.rawValue)
                    .tag($0)
            }
        }
        .onChange(of: vm.selectedGen) {
            Task { @MainActor in
                await vm.loadAllPokemon(for: vm.selectedGen)
            }
        }
    }
}

#Preview {
    GenPicker(vm: .constant(HomeScreen.ViewModel()))
}
