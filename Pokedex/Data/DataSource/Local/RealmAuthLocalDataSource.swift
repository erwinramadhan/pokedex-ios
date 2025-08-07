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


protocol UserLocalDataSourceProtocol {
    func fetchLoggedInUser() -> User?
    func saveUser(_ user: RealmUserObject) -> Observable<Void>
    func loginUser(id: String, password: String) -> Observable<User?>
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
    
    func fetchLoggedInUser() -> User? {
        guard let userObj = realm?.objects(RealmUserObject.self).first else {
            return nil
        }
        return userObj.toDomain()
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
