//
//  PokemonStatMapper.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 06/08/25.
//

enum PokemonStatNameMapper {
    static func shortName(for statName: String) -> String {
        switch statName.lowercased() {
        case "hp": return "HP"
        case "attack": return "ATK"
        case "defense": return "DEF"
        case "special-attack": return "SATK"
        case "special-defense": return "SDEF"
        case "speed": return "SPD"
        default: return statName.uppercased()
        }
    }
}
