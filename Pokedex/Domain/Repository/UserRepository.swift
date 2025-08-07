//
//  AuthRepository.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Foundation
import RxSwift

protocol UserRepositoryProtocol {
    func login(id: String, password: String) -> Observable<User?>
    func save(user: User) -> Observable<Void>
    func getCurrentUser() -> User?
    func logout()
}
