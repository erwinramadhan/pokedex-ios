//
//  RegisterUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 06/08/25.
//

import Foundation
import RxSwift

protocol RegisterUserUseCaseProtocol {
    func execute(user: User) -> Observable<Void>
}

class RegisterUserUseCaseImpl: RegisterUserUseCaseProtocol {
    
    let repository: UserRepositoryProtocol
    
    init (repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(user: User) -> Observable<Void> {
        return repository.save(user: user)
    }
    
}
