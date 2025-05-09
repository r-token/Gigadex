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

    var moves: [Move] {
        pokemon.details?.moves.filter { move in
            move.versionGroupDetails.contains { detail in
                detail.moveLearnMethod.name == "level-up"
            }
        }.sorted(by: { $0.versionGroupDetails.first?.levelLearnedAt ?? 0 < $1.versionGroupDetails.first?.levelLearnedAt ?? 0 }) ?? []
    }

    var defaultBackgroundColor: Color {
        pokemon.types.first?.color ?? .gray
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Learned Moves")
                .font(.title3)
            
            ForEach(moves, id: \.move.url) { move in
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

                        Text(moveName(move))

                        Spacer()
                    }
                    .padding(2)
                    .padding(.horizontal)
                    .background(movesAndTypes[move.move.name]?.color ?? defaultBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .task {
            await getMoveTypes(for: moves)
        }
    }

    private func moveLevel(_ move: Move) -> Int? {
        move.versionGroupDetails.first?.levelLearnedAt
    }

    private func moveName(_ move: Move) -> String {
        move.move.name.capitalized.replacingOccurrences(of: "-", with: " ")
    }

    private func getMoveTypes(for moves: [Move]) async {
        for move in moves {
            let moveName = move.move.name
            do {
                let moveDetail = try await API.fetchMoveDetails(for: moveName)
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
