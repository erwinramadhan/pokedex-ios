//
//  AuthRepositoryImpl.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Foundation

class AuthRepositoryImpl: AuthRepository {
    private let localDataSource: AuthLocalDataSource

    init(localDataSource: AuthLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func getLoggedInUser() -> User? {
        return localDataSource.fetchLoggedInUser()
    }
}
