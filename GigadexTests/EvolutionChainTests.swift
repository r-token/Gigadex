//
//  EvolutionChainTests.swift
//  GigadexTests
//
//  Created by Ryan Token on 5/9/25.
//

import Foundation
import Testing
@testable import Gigadex

@Suite
struct EvolutionChainTests {
    func createMockPokemon(id: String, name: String) -> Pokemon {
        var pokemon = Pokemon(id: id, name: name)
        pokemon.evolutionChain = createMockEvolutionChain()
        pokemon.evolutionChainSequence = [
            PokemonEvolution(
                name: "Bulbasaur",
                imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"),
                evolutionLevel: 0,
                trigger: nil,
                triggerCondition: nil
            ),
            PokemonEvolution(
                name: "Ivysaur",
                imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png"),
                evolutionLevel: 1,
                trigger: "level-up",
                triggerCondition: "min_level: 16"
            ),
            PokemonEvolution(
                name: "Venusaur",
                imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png"),
                evolutionLevel: 2,
                trigger: "level-up",
                triggerCondition: "min_level: 32"
            )
        ]
        return pokemon
    }

    func createMockEvolutionChain() -> EvolutionChain {
        return EvolutionChain(
            id: 1,
            babyTriggerItem: nil,
            chain: ChainLink(
                isBaby: false,
                species: NamedAPIResource(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
                evolutionDetails: [],
                evolvesTo: [
                    ChainLink(
                        isBaby: false,
                        species: NamedAPIResource(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon-species/2/"),
                        evolutionDetails: [
                            EvolutionDetail(
                                item: nil,
                                trigger: NamedAPIResource(name: "level-up", url: "https://pokeapi.co/api/v2/evolution-trigger/1/"),
                                gender: nil,
                                heldItem: nil,
                                knownMove: nil,
                                knownMoveType: nil,
                                location: nil,
                                minLevel: 16,
                                minHappiness: nil,
                                minBeauty: nil,
                                minAffection: nil,
                                needsOverworldRain: false,
                                partySpecies: nil,
                                partyType: nil,
                                relativePhysicalStats: nil,
                                timeOfDay: "",
                                tradeSpecies: nil,
                                turnUpsideDown: false
                            )
                        ],
                        evolvesTo: [
                            ChainLink(
                                isBaby: false,
                                species: NamedAPIResource(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon-species/3/"),
                                evolutionDetails: [
                                    EvolutionDetail(
                                        item: nil,
                                        trigger: NamedAPIResource(name: "level-up", url: "https://pokeapi.co/api/v2/evolution-trigger/1/"),
                                        gender: nil,
                                        heldItem: nil,
                                        knownMove: nil,
                                        knownMoveType: nil,
                                        location: nil,
                                        minLevel: 32,
                                        minHappiness: nil,
                                        minBeauty: nil,
                                        minAffection: nil,
                                        needsOverworldRain: false,
                                        partySpecies: nil,
                                        partyType: nil,
                                        relativePhysicalStats: nil,
                                        timeOfDay: "",
                                        tradeSpecies: nil,
                                        turnUpsideDown: false
                                    )
                                ],
                                evolvesTo: []
                            )
                        ]
                    )
                ]
            )
        )
    }
}

extension EvolutionChainTests {
    @Test func testEvolutionPosition() {
        // Setup
        let pokemon = createMockPokemon(id: "1", name: "Bulbasaur")

        // Verify
        #expect(pokemon.evolutionPosition == 0)
        #expect(pokemon.evolutionChainSequence.count == 3)
    }

    @Test func testNextEvolution() {
        // Setup
        let pokemon = createMockPokemon(id: "1", name: "Bulbasaur")

        // Verify
        let nextEvolution = pokemon.nextEvolution
        #expect(nextEvolution != nil)
        #expect(nextEvolution?.name == "Ivysaur")
        #expect(nextEvolution?.evolutionLevel == 1)
        #expect(nextEvolution?.trigger == "level-up")
        #expect(nextEvolution?.triggerCondition == "min_level: 16")
    }

    @Test func testPreviousEvolution() {
        // Setup
        let pokemon = createMockPokemon(id: "2", name: "Ivysaur")

        // Verify - should have Bulbasaur as previous evolution
        let previousEvolution = pokemon.previousEvolution
        #expect(previousEvolution != nil)
        #expect(previousEvolution?.name == "Bulbasaur")
        #expect(previousEvolution?.evolutionLevel == 0)
    }

    @Test func testFinalEvolution() {
        // Setup
        let pokemon = createMockPokemon(id: "3", name: "Venusaur")

        // Verify - should have Ivysaur as previous evolution
        let previousEvolution = pokemon.previousEvolution
        #expect(previousEvolution != nil)
        #expect(previousEvolution?.name == "Ivysaur")

        // Verify - should have no next evolution
        let nextEvolution = pokemon.nextEvolution
        #expect(nextEvolution == nil)
    }

    @Test func testExtractEvolutionChainInfo() {
        // This test would verify the logic that extracts evolution details from the chain
        // You might need to implement this method in your app that processes raw evolution chain data

        // Setup
        let chain = createMockEvolutionChain()

        // Verify
        #expect(chain.baseSpeciesId == "1")
        #expect(chain.chain.species.name == "bulbasaur")
        #expect(chain.chain.evolvesTo[0].species.name == "ivysaur")
        #expect(chain.chain.evolvesTo[0].evolutionDetails[0].minLevel == 16)
        #expect(chain.chain.evolvesTo[0].evolvesTo[0].species.name == "venusaur")
        #expect(chain.chain.evolvesTo[0].evolvesTo[0].evolutionDetails[0].minLevel == 32)
    }
}
