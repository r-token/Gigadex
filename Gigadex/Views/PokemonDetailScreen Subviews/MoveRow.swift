//
//  MoveRow.swift
//  Gigadex
//
//  Created by Ryan Token on 5/9/25.
//

import SwiftUI

struct MoveRow: View {
    let move: Move
    let movesAndTypes: [String: MoveType] // name: MoveType
    let defaultBackgroundColor: Color

    var body: some View {
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

            HStack {
                Image(systemName: moveImageName(move))
                    .font(.subheadline)
                Spacer()
                Text(moveType(move))
            }
            .padding()
            .frame(width: 275)
            .badgeStyle(using: moveTypeColor(move))
        }
        .padding(2)
        .padding(.horizontal)
        // .background(moveTypeColor(move))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func moveLevel(_ move: Move) -> Int? {
        move.versionGroupDetails.first?.levelLearnedAt
    }

    private func moveName(_ move: Move) -> String {
        move.move.name.capitalized.replacingOccurrences(of: "-", with: " ")
    }

    private func moveType(_ move: Move) -> String {
        movesAndTypes[move.move.name]?.type.name ?? "Unknown"
    }

    private func moveTypeColor(_ move: Move) -> Color {
        movesAndTypes[move.move.name]?.type.color ?? defaultBackgroundColor
    }

    private func moveImageName(_ move: Move) -> String {
        movesAndTypes[move.move.name]?.type.unstyledImageName ?? "questionmark.circle"
    }
}

#Preview {
    MoveRow(
        move: Move.sampleData,
        movesAndTypes: ["pay-day": MoveType(type: Type(name: "normal"), details: MoveDetail.sampleData)],
        defaultBackgroundColor: .blue
    )
}
