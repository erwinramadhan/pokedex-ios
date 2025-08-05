//
//  PokemonListResponseDTO+ext.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

extension PokemonListItemDTO {
    func toDomain() -> PokemonListItem {
        return PokemonListItem(
            name: name,
            id: extractID(from: url)
        )
    }

    private func extractID(from url: String) -> Int {
        let components = url.split(separator: "/")
        return Int(components.last ?? "0") ?? 0
    }
}

extension PokemonListResponseDTO {
    func toDomain() -> [PokemonListItem] {
        return results.map { $0.toDomain() }
    }
}
