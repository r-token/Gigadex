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
                    HStack {
                        Group {
                            if let levelLearned = moveLevel(move) {
                                Text("\(levelLearned)")
                            } else {
                                Text("?")
                            }
                        }
                        .fontWeight(.semibold)
                        .frame(width: 75)

                        Image(systemName: moveImageName(move))
                            .font(.subheadline)

                        Text(moveName(move))

                        Spacer()
                    }
                    .padding(2)
                    .padding(.horizontal)
                    .background(moveTypeColor(move))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .task {
            await setMoveTypes(for: pokemon.learnedMoves)
        }
    }

    private func moveLevel(_ move: Move) -> Int? {
        move.versionGroupDetails.first?.levelLearnedAt
    }

    private func moveName(_ move: Move) -> String {
        move.move.name.capitalized.replacingOccurrences(of: "-", with: " ")
    }

    private func moveTypeColor(_ move: Move) -> Color {
        movesAndTypes[move.move.name]?.color ?? defaultBackgroundColor
    }

    private func moveImageName(_ move: Move) -> String {
        movesAndTypes[move.move.name]?.unstyledImageName ?? "questionmark.circle"
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
