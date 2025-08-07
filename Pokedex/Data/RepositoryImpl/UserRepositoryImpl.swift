//
//  UserRepositoryImpl.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import RealmSwift
import RxSwift

final class UserRepositoryImpl: UserRepositoryProtocol {
//    private let realm: Realm
    
    // Realm
    private let localDataSource: UserLocalDataSourceProtocol
    
//    init(realm: Realm) {
//        self.realm = realm
//    }
    
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
    
    func getCurrentUser() -> User? {
//        let currentUserId = UserDefaults.standard.string(forKey: "currentUserId")
//        guard let id = currentUserId,
//              let realmUser = realm.object(ofType: RealmUserObject.self, forPrimaryKey: id) else {
//            return nil
//        }
//        return realmUser.toDomain()
        return nil
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "currentUserId")
        UserDefaults.standard.synchronize()
    }
    
}
