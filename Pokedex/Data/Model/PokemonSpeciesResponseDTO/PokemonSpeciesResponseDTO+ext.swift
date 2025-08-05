//
//  PokemonSpeciesResponseDTO+ext.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import Foundation

extension PokemonSpeciesResponseDTO {
    func firstEnglishFlavorText() -> String? {
        return flavorTextEntries.first(where: { $0.language.name == "en" })?.flavorText
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{000c}", with: " ")
    }
}
