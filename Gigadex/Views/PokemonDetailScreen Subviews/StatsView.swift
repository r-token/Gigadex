//
//  StatsView.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct StatsView: View {
    let pokemon: Pokemon

    var body: some View {
        VStack(alignment: .leading) {
            Text("Stats")
                .font(.title3)

            HStack {
                // stat names column
                VStack(alignment: .leading) {
                    ForEach(pokemon.stats, id: \.stat.url) { stat in
                        Text(cleanStat(stat))
                    }
                }
                // stat progress column
                VStack {
                    ForEach(pokemon.stats, id: \.stat.url) { stat in
                        ProgressView(value: cleanProgress(stat))
                            .progressViewStyle(.linear)
                    }
                }
                // stat number column
                VStack(alignment: .trailing) {
                    ForEach(pokemon.stats, id: \.stat.url) { stat in
                        Text("\(stat.baseStat)")
                    }
                }
            }
        }
    }

    private func cleanStat(_ stat: Stat) -> String {
        let cleanStat = stat.stat.name.capitalized.replacingOccurrences(of: "-", with: " ")
        return cleanStat == "Hp" ? "HP" : cleanStat
    }

    private func cleanProgress(_ stat: Stat) -> Double {
       Double(stat.baseStat) / 255.0
    }
}

#Preview {
    StatsView(pokemon: Pokemon.sampleData)
}
