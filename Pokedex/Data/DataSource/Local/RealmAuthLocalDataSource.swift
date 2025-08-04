//
//  RealmAuthLocalDataSource.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Foundation
import RealmSwift

class RealmUserObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
}

protocol AuthLocalDataSource {
    func fetchLoggedInUser() -> User?
}

class RealmAuthLocalDataSource: AuthLocalDataSource {
    func fetchLoggedInUser() -> User? {
        let realm = try! Realm()
        guard let userObj = realm.objects(RealmUserObject.self).first else {
            return nil
        }
        return User(id: userObj.id, name: userObj.name)
    }
}

