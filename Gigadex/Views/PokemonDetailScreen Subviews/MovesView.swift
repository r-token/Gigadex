//
//  MovesView.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct MovesView: View {
    let pokemon: Pokemon
    @State private var movesAndTypes = [String: Type]() // move name: type

    var defaultBackgroundColor: Color {
        pokemon.types.first?.color ?? .gray
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Learned Moves")
                .font(.title3)
            
            ForEach(pokemon.learnedMoves, id: \.move.url) { move in
                Button(action: {}) {
                    MoveRow(
                        move: move,
                        movesAndTypes: movesAndTypes,
                        defaultBackgroundColor: defaultBackgroundColor
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .task {
            await setMoveTypes(for: pokemon.learnedMoves)
        }
    }

    private func setMoveTypes(for moves: [Move]) async {
        for move in moves {
            let moveName = move.move.name
            do {
                let moveDetail = try await API.Request.fetchMoveDetails(for: moveName)
                let moveType = Type(name: moveDetail.type.name)
                withAnimation {
                    movesAndTypes[moveName] = moveType
                }
            } catch {
                print("Error mapping moves to types: \(error)")
            }
        }
    }
}

#Preview {
    MovesView(pokemon: Pokemon.sampleData)
}
