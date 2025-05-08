//
//  Type.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import SwiftUI

struct Type: Identifiable {
    let id = UUID()
    var name: String
    var imageName: String
    var color: Color

    init(name: String) {
        self.name = name

        switch name {
        case "normal":
            imageName = "circle.circle.fill"
            color = .gray
        case "fighting":
            imageName = "figure.kickboxing.circle.fill"
            color = .red
        case "flying":
            imageName = "bird.circle.fill"
            color = .mint
        case "poison":
            imageName = "arrowtriangle.down.circle.fill"
            color = .purple
        case "ground":
            imageName = "globe.asia.australia.fill"
            color = .brown
        case "rock":
            imageName = "mountain.2.circle.fill"
            color = .white
        case "bug":
            imageName = "ladybug.circle.fill"
            color = .green
        case "ghost":
            imageName = "aqi.medium"
            color = .indigo
        case "steel":
            imageName = "gearshape.circle.fill"
            color = .teal
        case "fire":
            imageName = "flame.circle.fill"
            color = .orange
        case "water":
            imageName = "drop.circle.fill"
            color = .blue
        case "grass":
            imageName = "leaf.circle.fill"
            color = .green
        case "electric":
            imageName = "bolt.circle.fill"
            color = .yellow
        case "psychic":
            imageName = "apple.image.playground.fill"
            color = .pink
        case "ice":
            imageName = "snowflake.circle.fill"
            color = .mint
        case "dragon":
            imageName = "wind.snow.circle.fill"
            color = .purple
        case "dark":
            imageName = "moon.circle.fill"
            color = .black
        case "fairy":
            imageName = "heart.circle.fill"
            color = .pink
        case "stellar":
            imageName = "star.circle.fill"
            color = .indigo
        default:
            imageName = "questionmark.circle.fill"
            color = .black
        }
    }
}
