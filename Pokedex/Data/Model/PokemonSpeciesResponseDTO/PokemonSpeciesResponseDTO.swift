//
//  PokemonSpeciesResponseDTO.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import Foundation

struct PokemonSpeciesResponseDTO: Decodable {
    let flavorTextEntries: [FlavorTextEntryDTO]
    let color: ColorDTO

    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
        case color
    }
}

struct FlavorTextEntryDTO: Decodable {
    let flavorText: String
    let language: NamedAPIResourceDTO
    let version: NamedAPIResourceDTO

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case version
    }
}

struct ColorDTO: Decodable {
    let name: String
}

extension PokemonSpeciesResponseDTO {
    static var empty: PokemonSpeciesResponseDTO {
        return PokemonSpeciesResponseDTO(
            flavorTextEntries: [],
            color: .empty
        )
    }
}

extension FlavorTextEntryDTO {
    static var empty: FlavorTextEntryDTO {
        return FlavorTextEntryDTO(
            flavorText: "",
            language: .empty,
            version: .empty
        )
    }
}

extension ColorDTO {
    static var empty: ColorDTO {
        return ColorDTO(name: "gray")
    }
}
