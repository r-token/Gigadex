//
//  APITests.swift
//  GigadexTests
//
//  Created by Ryan Token on 5/9/25.
//

import Testing
import Combine
@testable import Gigadex

@Suite
struct APITests {
    private var cancellables = Set<AnyCancellable>()

    // Mock API implementation that doesn't make real network requests
    class MockAPI: CoreAPI {
        static var mockPokemonList: [Pokemon] = []
        static var mockPokemonDetails: PokemonDetails?
        static var mockPokemonSpecies: PokemonSpecies?
        static var mockEvolutionChain: EvolutionChain?
        static var mockMoveDetails: MoveDetail?
        static var shouldThrowError = false

        static func fetchAllPokemon(for gen: PokemonGen) async throws -> [Pokemon] {
            if shouldThrowError {
                throw APIError("Mock error")
            }
            return mockPokemonList
        }

        static func fetchDetails(for pokemonId: String) async throws -> PokemonDetails {
            if shouldThrowError {
                throw APIError("Mock error")
            }
            guard let details = mockPokemonDetails else {
                throw APIError("No mock details provided")
            }
            return details
        }

        static func fetchSpeciesInfo(for pokemonId: String) async throws -> PokemonSpecies {
            if shouldThrowError {
                throw APIError("Mock error")
            }
            guard let species = mockPokemonSpecies else {
                throw APIError("No mock species provided")
            }
            return species
        }

        static func fetchEvolutionChain(for chainId: String) async throws -> EvolutionChain {
            if shouldThrowError {
                throw APIError("Mock error")
            }
            guard let chain = mockEvolutionChain else {
                throw APIError("No mock evolution chain provided")
            }
            return chain
        }

        static func fetchMoveDetails(for move: String) async throws -> MoveDetail {
            if shouldThrowError {
                throw APIError("Mock error")
            }
            guard let details = mockMoveDetails else {
                throw APIError("No mock move details provided")
            }
            return details
        }

        static func pokemonPublisher(for gen: PokemonGen) -> AnyPublisher<[Pokemon], Error> {
            if shouldThrowError {
                return Fail(error: APIError("Mock error")).eraseToAnyPublisher()
            }
            return Just(mockPokemonList)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        static func reset() {
            mockPokemonList = []
            mockPokemonDetails = nil
            mockPokemonSpecies = nil
            mockEvolutionChain = nil
            mockMoveDetails = nil
            shouldThrowError = false
        }
    }

    // Setup mock data for tests
    func setupMockData() {
        MockAPI.mockPokemonList = [
            Pokemon(id: "1", name: "Bulbasaur"),
            Pokemon(id: "4", name: "Charmander"),
            Pokemon(id: "7", name: "Squirtle")
        ]

        MockAPI.mockPokemonDetails = PokemonDetails(
            id: 1,
            name: "bulbasaur",
            baseExperience: 64,
            height: 7,
            weight: 69,
            sprites: Sprites(
                frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                frontShiny: nil,
                frontFemale: nil,
                frontShinyFemale: nil,
                backDefault: nil,
                backShiny: nil,
                backFemale: nil,
                backShinyFemale: nil,
                other: Other(
                    officialArtwork: OfficialArtwork(
                        frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                        frontShiny: nil
                    ),
                    dreamWorld: nil,
                    home: nil
                )
            ),
            stats: [
                Stat(baseStat: 45, effort: 0, stat: Species(name: "hp", url: "https://pokeapi.co/api/v2/stat/1/")),
                Stat(baseStat: 49, effort: 0, stat: Species(name: "attack", url: "https://pokeapi.co/api/v2/stat/2/"))
            ],
            types: [
                TypeElement(slot: 1, type: Species(name: "grass", url: "https://pokeapi.co/api/v2/type/12/")),
                TypeElement(slot: 2, type: Species(name: "poison", url: "https://pokeapi.co/api/v2/type/4/"))
            ],
            abilities: [
                Ability(ability: Species(name: "overgrow", url: "https://pokeapi.co/api/v2/ability/65/"), isHidden: false, slot: 1)
            ],
            moves: [
                Move(
                    move: Species(name: "razor-wind", url: "https://pokeapi.co/api/v2/move/13/"),
                    versionGroupDetails: [
                        VersionGroupDetail(
                            levelLearnedAt: 0,
                            moveLearnMethod: Species(name: "egg", url: "https://pokeapi.co/api/v2/move-learn-method/2/"),
                            versionGroup: Species(name: "gold-silver", url: "https://pokeapi.co/api/v2/version-group/3/")
                        )
                    ]
                )
            ],
            species: Species(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
            order: 1,
            isDefault: true,
            formOrder: 1
        )

        MockAPI.mockPokemonSpecies = PokemonSpecies(
            baseHappiness: 70,
            captureRate: 45,
            color: NamedAPIResource(name: "green", url: "https://pokeapi.co/api/v2/pokemon-color/5/"),
            eggGroups: [
                NamedAPIResource(name: "monster", url: "https://pokeapi.co/api/v2/egg-group/1/"),
                NamedAPIResource(name: "plant", url: "https://pokeapi.co/api/v2/egg-group/7/")
            ],
            evolutionChain: APIResource(url: "https://pokeapi.co/api/v2/evolution-chain/1/"),
            evolvesFromSpecies: nil,
            flavorTextEntries: [
                FlavorTextEntry(
                    flavorText: "A strange seed was planted on its back at birth. The plant sprouts and grows with this POKéMON.",
                    language: NamedAPIResource(name: "en", url: "https://pokeapi.co/api/v2/language/9/"),
                    version: NamedAPIResource(name: "red", url: "https://pokeapi.co/api/v2/version/1/")
                )
            ],
            formDescriptions: [],
            formsSwitchable: false,
            genderRate: 1,
            genera: [
                Genus(
                    genus: "Seed Pokémon",
                    language: NamedAPIResource(name: "en", url: "https://pokeapi.co/api/v2/language/9/")
                )
            ],
            order: 1,
            palParkEncounters: [
                PalParkEncounter(
                    area: NamedAPIResource(name: "field", url: "https://pokeapi.co/api/v2/pal-park-area/2/"),
                    baseScore: 50,
                    rate: 30
                )
            ],
            pokedexNumbers: [
                PokedexNumber(
                    entryNumber: 1,
                    pokedex: NamedAPIResource(name: "national", url: "https://pokeapi.co/api/v2/pokedex/1/")
                )
            ],
            shape: NamedAPIResource(name: "quadruped", url: "https://pokeapi.co/api/v2/pokemon-shape/8/"),
            varieties: [
                Variety(
                    isDefault: true,
                    pokemon: NamedAPIResource(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
                )
            ]
        )

        MockAPI.mockEvolutionChain = EvolutionChain(
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

extension APITests {
    // Test fetching all Pokemon for a generation
    @Test func testFetchAllPokemon() async throws {
        // Setup
        MockAPI.reset()
        setupMockData()

        // Execute
        let pokemon = try await MockAPI.fetchAllPokemon(for: .gen1)

        // Verify
        #expect(pokemon.count == 3)
        #expect(pokemon[0].name == "Bulbasaur")
        #expect(pokemon[1].name == "Charmander")
        #expect(pokemon[2].name == "Squirtle")

        try await testFetchPokemonDetails()
        try await testFetchPokemonSpecies()
        try await testFetchEvolutionChain()
    }

    // Test error handling when fetching Pokemon
    @Test func testFetchAllPokemonError() async {
        // Setup
        MockAPI.reset()
        MockAPI.shouldThrowError = true

        // Execute and Verify
        do {
            _ = try await MockAPI.fetchAllPokemon(for: .gen1)
            Issue.record("Expected an error to be thrown")
        } catch let error as APIError {
            if case .message(let message) = error {
                #expect(message == "Mock error")
            } else {
                Issue.record("Unexpected error type")
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    // Test fetching Pokemon details
    func testFetchPokemonDetails() async throws {
        // Setup
        MockAPI.reset()
        setupMockData()

        // Execute
        let details = try await MockAPI.fetchDetails(for: "1")

        // Verify
        #expect(details.id == 1)
        #expect(details.name == "bulbasaur")
        #expect(details.types.count == 2)
        #expect(details.types[0].type.name == "grass")
        #expect(details.types[1].type.name == "poison")
    }

    // Test fetching Pokemon species
    func testFetchPokemonSpecies() async throws {
        // Setup
        MockAPI.reset()
        setupMockData()

        // Execute
        let species = try await MockAPI.fetchSpeciesInfo(for: "1")

        // Verify
        #expect(species.evolutionChain.url == "https://pokeapi.co/api/v2/evolution-chain/1/")
        #expect(species.flavorTextEntries.first?.language.name == "en")
    }

    // Test fetching evolution chain
    func testFetchEvolutionChain() async throws {
        // Setup
        MockAPI.reset()
        setupMockData()

        // Execute
        let chain = try await MockAPI.fetchEvolutionChain(for: "1")

        // Verify
        #expect(chain.chain.species.name == "bulbasaur")
        #expect(chain.chain.evolvesTo.count == 1)
        #expect(chain.chain.evolvesTo[0].species.name == "ivysaur")
        #expect(chain.chain.evolvesTo[0].evolutionDetails[0].minLevel == 16)
        #expect(chain.chain.evolvesTo[0].evolvesTo[0].species.name == "venusaur")
        #expect(chain.chain.evolvesTo[0].evolvesTo[0].evolutionDetails[0].minLevel == 32)
    }
}
