//
//  PokemonDetailResponseDTO+ext.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import Foundation

extension PokemonDetailResponseDTO {
    func toDomain() -> PokemonDetail {
        return PokemonDetail(
            id: id,
            name: name.capitalized,
            height: "\(height / 10) m",
            weight: "\(weight / 10) kg",
            baseExperience: baseExperience,
            types: types.map { PokemonType(name: $0.type.name, slot: $0.slot) },
            abilities: abilities.map {
                PokemonAbility(
                    name: $0.ability.name,
                    isHidden: $0.isHidden,
                    slot: $0.slot
                )
            },
            stats: stats.map {
                PokemonStat(
                    name: $0.stat.name,
                    baseStat: $0.baseStat,
                    effort: $0.effort
                )
            },
            imageURL: sprites.frontDefault,
            description: nil
        )
    }
}
