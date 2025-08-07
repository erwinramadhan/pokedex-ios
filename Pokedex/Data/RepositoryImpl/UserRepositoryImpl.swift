//
//  UserRepositoryImpl.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import RealmSwift
import RxSwift

final class UserRepositoryImpl: UserRepositoryProtocol {
    // Data Source
    private let localDataSource: UserLocalDataSourceProtocol
    
    init(localDataSource: UserLocalDataSourceProtocol) {
        self.localDataSource = localDataSource
    }
    
    func login(id: String, password: String) -> Observable<User?> {
        return localDataSource.loginUser(id: id, password: password)
    }
    
    func save(user: User) -> Observable<Void> {
        let realmUser = RealmUserObject.fromDomain(user)
        
        return localDataSource.saveUser(realmUser)
    }
    
    func getCurrentUser() -> Observable<User?> {
        return localDataSource.fetchLoggedInUser()
    }
    
    func addFavoritePokemon(pokemon: PokemonDetail) -> Observable<Void> {
        let favoritedPokemon = pokemon.toRealmFavoriteObject()
        return localDataSource.addFavoritePokemon(favoritedPokemon)
    }
    
    func isPokemonInFavorite(pokemonId: Int) -> Observable<Bool> {
        return localDataSource.isPokemonInFavorite(pokemonId: pokemonId)
    }
    
    func removeFavoritePokemon(pokemon: PokemonDetail) -> Observable<Void> {
        let favoritedPokemon = pokemon.toRealmFavoriteObject()
        return localDataSource.removeFavoritePokemon(favoritedPokemon)
    }
    
    func getListFavoritePokemon() -> Observable<[RealmFavoritePokemonObject]> {
        return localDataSource.getListFavoritePokemon()
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "currentUserId")
        UserDefaults.standard.synchronize()
    }
    
}
