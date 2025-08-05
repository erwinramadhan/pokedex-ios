//
//  PokemonDetailResponseDTO.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import Foundation

struct PokemonDetailResponseDTO: Decodable {
    let id: Int
    let name: String
    let height: CGFloat
    let weight: CGFloat
    let baseExperience: Int?
    let types: [PokemonTypeEntryDTO]
    let abilities: [PokemonAbilityEntryDTO]
    let stats: [PokemonStatEntryDTO]
    let sprites: PokemonSpritesDTO
    let moves: [PokemonMoveEntryDTO]
    let species: NamedAPIResourceDTO
}

struct PokemonTypeEntryDTO: Decodable {
    let slot: Int
    let type: NamedAPIResourceDTO
}

struct PokemonAbilityEntryDTO: Decodable {
    let ability: NamedAPIResourceDTO
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

struct PokemonStatEntryDTO: Decodable {
    let baseStat: Int
    let effort: Int
    let stat: NamedAPIResourceDTO

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

struct PokemonMoveEntryDTO: Decodable {
    let move: NamedAPIResourceDTO
}

struct PokemonSpritesDTO: Decodable {
    let frontDefault: String?
    let backDefault: String?
    let frontShiny: String?
    let backShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case frontShiny = "front_shiny"
        case backShiny = "back_shiny"
    }
}

struct NamedAPIResourceDTO: Decodable {
    let name: String
    let url: String
}

extension PokemonDetailResponseDTO {
    static var empty: PokemonDetailResponseDTO {
        return PokemonDetailResponseDTO(
            id: 0,
            name: "",
            height: 0,
            weight: 0,
            baseExperience: 0,
            types: [],
            abilities: [],
            stats: [],
            sprites: .empty,
            moves: [],
            species: .empty
        )
    }
}

extension PokemonSpritesDTO {
    static var empty: PokemonSpritesDTO {
        return PokemonSpritesDTO(
            frontDefault: nil,
            backDefault: nil,
            frontShiny: nil,
            backShiny: nil
        )
    }
}

extension NamedAPIResourceDTO {
    static var empty: NamedAPIResourceDTO {
        return NamedAPIResourceDTO(
            name: "",
            url: ""
        )
    }
}
