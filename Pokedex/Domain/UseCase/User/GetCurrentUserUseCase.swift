//
//  GetCurrentUserUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 06/08/25.
//

protocol GetCurrentUserUseCaseProtocol {
    func execute() -> User?
}

class GetCurrentUserUseCaseImpl: GetCurrentUserUseCaseProtocol {
    
    let repository: UserRepositoryProtocol
    
    init (repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> User? {
        return repository.getCurrentUser()
    }
}
