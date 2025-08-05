//
//  PokemonColorMapper.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import UIKit

enum PokemonColorMapper {
    static func uiColor(for colorName: String) -> UIColor {
        switch colorName.lowercased() {
        case "red": return UIColor(hex: "DC0A2D", alpha: 1.0)
        case "blue": return .systemBlue
        case "green": return .systemGreen
        case "yellow": return .systemYellow
        case "black": return .black
        case "white": return .gray
        case "gray": return .darkGray
        case "purple": return .systemPurple
        case "pink": return .systemPink
        case "brown": return .brown
        default: return .lightGray
        }
    }
}
