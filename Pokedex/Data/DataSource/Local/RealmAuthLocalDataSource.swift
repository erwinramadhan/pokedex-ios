//
//  RealmAuthLocalDataSource.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Foundation
import RealmSwift
import RxSwift

class RealmUserObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var password: String
    
    // Relation: one user have many favorite Pokémon
    @Persisted var favoritePokemons: List<RealmFavoritePokemonObject>
}

class RealmFavoritePokemonObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var imageUrl: String
}

extension RealmFavoritePokemonObject {
    func toFavoritePokemon() -> PokemonListItem {
        return PokemonListItem(name: name, id: id, image: imageUrl)
    }
}


protocol UserLocalDataSourceProtocol {
    func fetchLoggedInUser() -> Observable<User?>
    func saveUser(_ user: RealmUserObject) -> Observable<Void>
    func loginUser(id: String, password: String) -> Observable<User?>
    func getListFavoritePokemon() -> Observable<[RealmFavoritePokemonObject]>
    func addFavoritePokemon(_ favorite: RealmFavoritePokemonObject) -> Observable<Void>
    func removeFavoritePokemon(_ favorite: RealmFavoritePokemonObject) -> Observable<Void>
    func isPokemonInFavorite(pokemonId: Int) -> Observable<Bool>
}

class RealmAuthLocalDataSource: UserLocalDataSourceProtocol {
    private let realm: Realm?
    
    init(realm: Realm?) {
        self.realm = realm
    }
    
    func saveUser(_ user: RealmUserObject) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            if let realm = self?.realm {
                do {
                    try realm.write {
                        realm.add(user, update: .all)
                        observer.onNext(())
                    }
                } catch(let error) {
                    observer.onError(error)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func loginUser(id: String, password: String) -> Observable<User?> {
        return Observable.create { [weak self] observer in
            if let realm = self?.realm {
                if let realmUser = realm.object(ofType: RealmUserObject.self, forPrimaryKey: id) {
                    let hasher = PasswordHasher()
                    if hasher.verify(password: password, storedHash: realmUser.password) {
                        observer.onNext(realmUser.toDomain())
                    } else {
                        observer.onError(LoginError.passwordNotMatch)
                    }
                } else {
                    observer.onError(LoginError.userNotFound)
                }
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func fetchLoggedInUser() -> Observable<User?> {
        return Observable.create { [weak self] observer in
            guard let self, let realm else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let currentUserId = UserDefaults.standard.string(forKey: "currentUserId")
            guard let currentUserId, let userObj = realm.object(ofType: RealmUserObject.self, forPrimaryKey: currentUserId) else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            
            observer.onNext(userObj.toDomain())
            
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func addFavoritePokemon(_ favorite: RealmFavoritePokemonObject) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self, let realm = self.realm else {
                observer.onError(DatabaseError.invalidInstance)
                return Disposables.create()
            }
            
            guard let currentUserId = UserDefaults.standard.string(forKey: "currentUserId"),
                  let userObject = realm.object(ofType: RealmUserObject.self, forPrimaryKey: currentUserId) else {
                observer.onError(LoginError.userNotFound)
                return Disposables.create()
            }
            
            do {
                try realm.write {
                    realm.add(favorite, update: .modified)
                    
                    if userObject.favoritePokemons.first(where: { $0.id == favorite.id }) == nil {
                        userObject.favoritePokemons.append(favorite)
                        observer.onNext(())
                    } else {
                        observer.onError(FavoritePokemonError.alreadyAddedToFavorite)
                    }
                }
            } catch (let error) {
                observer.onError(error)
            }
            
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func removeFavoritePokemon(_ favorite: RealmFavoritePokemonObject) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self, let realm = self.realm else {
                observer.onError(DatabaseError.invalidInstance)
                return Disposables.create()
            }
            
            guard let currentUserId = UserDefaults.standard.string(forKey: "currentUserId"),
                  let userObject = realm.object(ofType: RealmUserObject.self, forPrimaryKey: currentUserId) else {
                observer.onError(LoginError.userNotFound)
                return Disposables.create()
            }
            
            do {
                try realm.write {
                    if userObject.favoritePokemons.first(where: { $0.id == favorite.id }) != nil {
                        if let index = userObject.favoritePokemons.firstIndex(where: { $0.id == favorite.id }) {
                            let objectToDelete = userObject.favoritePokemons[index]
                            userObject.favoritePokemons.remove(at: index)
                            realm.delete(objectToDelete)
                            observer.onNext(())
                        }
                    } else {
                        observer.onError(FavoritePokemonError.alreadyRemovedFromFavorite)
                    }
                }
            } catch (let error) {
                observer.onError(error)
            }
            
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func isPokemonInFavorite(pokemonId: Int) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self, let realm = self.realm else {
                observer.onError(DatabaseError.invalidInstance)
                return Disposables.create()
            }
            
            guard let currentUserId = UserDefaults.standard.string(forKey: "currentUserId"),
                  let userObject = realm.object(ofType: RealmUserObject.self, forPrimaryKey: currentUserId) else {
                observer.onError(LoginError.userNotFound)
                return Disposables.create()
            }
            
            let result = userObject.favoritePokemons.contains(where: { $0.id == pokemonId })
            observer.onNext(result)
            
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getListFavoritePokemon() -> Observable<[RealmFavoritePokemonObject]> {
        return Observable.create { [weak self] observer in
            guard let self, let realm = self.realm else {
                observer.onError(DatabaseError.invalidInstance)
                return Disposables.create()
            }
            
            guard let currentUserId = UserDefaults.standard.string(forKey: "currentUserId"),
                  let userObject = realm.object(ofType: RealmUserObject.self, forPrimaryKey: currentUserId) else {
                observer.onError(LoginError.userNotFound)
                return Disposables.create()
            }
            
            let result = Array(userObject.favoritePokemons)
            observer.onNext(result)
            
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}

enum LoginError: LocalizedError {
    case passwordNotMatch
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .passwordNotMatch: return "Password not match"
        case .userNotFound: return "User not found"
        }
    }
}

enum FavoritePokemonError: LocalizedError {
    case alreadyAddedToFavorite
    case alreadyRemovedFromFavorite
    
    var errorDescription: String? {
        switch self {
        case .alreadyAddedToFavorite: return "This Pokemon is already added to your favorite."
        case .alreadyRemovedFromFavorite: return "This Pokemon is already removed from your favorite."
        }
    }
}

enum DatabaseError: LocalizedError {
    case invalidInstance
    case requestFailed
    case emptyData
    
    var errorDescription: String? {
        switch self {
        case .invalidInstance: return "Database can't instance."
        case .requestFailed: return "Your request failed."
        case .emptyData: return "Data doesn't exist"
        }
    }
    
}
