//
//  PokemonTypeColorMapper.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 06/08/25.
//

import UIKit

enum PokemonTypeColorMapper {
    static func color(for typeName: String) -> UIColor {
        switch typeName.lowercased() {
        case "normal": return .systemGray
        case "fire": return UIColor(hex: "DC0A2D", alpha: 1.0)
        case "water": return .systemBlue
        case "electric": return .systemYellow
        case "grass": return .systemGreen
        case "ice": return .cyan
        case "fighting": return .systemOrange
        case "poison": return .systemPurple
        case "ground": return .brown
        case "flying": return .systemTeal
        case "psychic": return .magenta
        case "bug": return .systemGreen
        case "rock": return .darkGray
        case "ghost": return .purple
        case "dragon": return .systemIndigo
        case "dark": return .black
        case "steel": return .gray
        case "fairy": return .systemPink
        default: return .lightGray
        }
    }
}
