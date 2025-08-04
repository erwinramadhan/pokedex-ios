//
//  AuthStateUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Foundation

class AuthStateUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func isUserLoggedIn() -> Bool {
        return repository.getLoggedInUser() != nil
    }
}
