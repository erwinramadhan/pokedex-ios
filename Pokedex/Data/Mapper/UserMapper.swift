//
//  UserMapper.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 06/08/25.
//

extension RealmUserObject {
    func toDomain() -> User {
        return User(
            id: id,
            name: name,
            password: password,
            favorites: favoritePokemons.map { $0.toDomain() }
        )
    }
    
    static func fromDomain(_ user: User) -> RealmUserObject {
        let obj = RealmUserObject()
        obj.id = user.id
        obj.name = user.name
        obj.password = user.password
        obj.favoritePokemons.append(objectsIn: user.favorites.map { RealmFavoritePokemonObject.fromDomain($0) })
        return obj
    }
}

extension RealmFavoritePokemonObject {
    func toDomain() -> FavoritePokemon {
        return FavoritePokemon(id: id, name: name, imageUrl: imageUrl)
    }
    
    static func fromDomain(_ fav: FavoritePokemon) -> RealmFavoritePokemonObject {
        let obj = RealmFavoritePokemonObject()
        obj.id = fav.id
        obj.name = fav.name
        obj.imageUrl = fav.imageUrl
        return obj
    }
}
