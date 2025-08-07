//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import UIKit

struct PokemonDetail {
    let id: Int
    let name: String
    let height: String
    let weight: String
    let baseExperience: Int?
    let types: [PokemonType]
    let abilities: [PokemonAbility]
    let stats: [PokemonStat]
    let imageURL: String?
    var description: String?
    var color: String?
}

struct PokemonType {
    let name: String
    let slot: Int
}

struct PokemonAbility {
    let name: String
    let isHidden: Bool
    let slot: Int
}

struct PokemonStat {
    let name: String
    let baseStat: Int
    let effort: Int
}

extension PokemonDetail {
    func toRealmFavoriteObject() -> RealmFavoritePokemonObject {
        let realmObject = RealmFavoritePokemonObject()
        realmObject.id = self.id
        realmObject.name = self.name
        realmObject.imageUrl = self.imageURL ?? ""
        return realmObject
    }
}

