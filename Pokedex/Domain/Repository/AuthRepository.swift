//
//  AuthRepository.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Foundation

protocol AuthRepository {
    func getLoggedInUser() -> User?
}
