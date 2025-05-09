//
//  UtilsAndTypeTests.swift
//  GigadexTests
//
//  Created by Ryan Token on 5/9/25.
//

import Testing
@testable import Gigadex

@Suite
struct UtilsTests {
    @Test func testGetIdFromUrl() {
        // Test normal URL
        let url1 = "https://pokeapi.co/api/v2/pokemon/25/"
        #expect(Utils.getId(from: url1) == "25")

        // Test URL without trailing slash
        let url2 = "https://pokeapi.co/api/v2/pokemon/150"
        #expect(Utils.getId(from: url2) == "150")

        // Test URL with different endpoint
        let url3 = "https://pokeapi.co/api/v2/evolution-chain/10/"
        #expect(Utils.getId(from: url3) == "10")

        // Test invalid URL
        let url4 = "invalid-url"
        #expect(Utils.getId(from: url4) == "invalid-url")

        // Test URL with query parameters (edge case)
        let url5 = "https://pokeapi.co/api/v2/pokemon/25?limit=10"
        #expect(Utils.getId(from: url5) == "25?limit=10") // This is the current behavior
    }
}

struct TypeTests {
    @Test func testFireType() {
        let type = Type(name: "Fire")
        #expect(type.name == "Fire")
        #expect(type.imageName == "flame.circle.fill")
        #expect(type.color == .orange)
        #expect(type.unstyledImageName == "flame")
    }

    @Test func testWaterType() {
        let type = Type(name: "Water")
        #expect(type.name == "Water")
        #expect(type.imageName == "drop.circle.fill")
        #expect(type.color == .blue)
        #expect(type.unstyledImageName == "drop")
    }

    @Test func testElectricType() {
        let type = Type(name: "electric") // Test lowercase
        #expect(type.name == "electric")
        #expect(type.imageName == "bolt.circle.fill")
        #expect(type.color == .yellow)
    }

    @Test func testAllTypes() {
        let typeNames = [
            "normal", "fighting", "flying", "poison", "ground",
            "rock", "bug", "ghost", "steel", "fire",
            "water", "grass", "electric", "psychic", "ice",
            "dragon", "dark", "fairy", "stellar"
        ]

        for typeName in typeNames {
            let type = Type(name: typeName)
            #expect(type.name == typeName)
            #expect(!type.imageName.isEmpty)
            #expect(type.imageName != "questionmark.circle.fill")
        }
    }

    @Test func testUnknownType() {
        let type = Type(name: "unknown")
        #expect(type.name == "unknown")
        #expect(type.imageName == "questionmark.circle.fill")
        #expect(type.color == .black)
    }

    @Test func testCaseInsensitivity() {
        let type1 = Type(name: "FIRE")
        let type2 = Type(name: "Fire")
        let type3 = Type(name: "fire")

        #expect(type1.imageName == type2.imageName)
        #expect(type2.imageName == type3.imageName)
        #expect(type1.color == type2.color)
        #expect(type2.color == type3.color)
    }

    @Test func testUnstyledImageName() {
        let type1 = Type(name: "normal")
        #expect(type1.unstyledImageName == "circle")

        let type2 = Type(name: "fighting")
        #expect(type2.unstyledImageName == "figure.boxing")

        let type3 = Type(name: "ghost")
        #expect(type3.unstyledImageName == "aqi.medium")
    }
}
