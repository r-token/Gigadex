//
//  MovesView.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct MovesView: View {
    let pokemon: Pokemon

    var moves: [Move] {
        pokemon.details?.moves.filter { move in
            move.versionGroupDetails.contains { detail in
                detail.moveLearnMethod.name == "level-up"
            }
        }.sorted(by: { $0.versionGroupDetails.first?.levelLearnedAt ?? 0 < $1.versionGroupDetails.first?.levelLearnedAt ?? 0 }) ?? []
    }

    var backgroundColor: Color {
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
                    .background(backgroundColor.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func moveLevel(_ move: Move) -> Int? {
        move.versionGroupDetails.first?.levelLearnedAt
    }

    private func moveName(_ move: Move) -> String {
        move.move.name.capitalized.replacingOccurrences(of: "-", with: " ")
    }
}

#Preview {
    MovesView(pokemon: Pokemon.sampleData)
}
