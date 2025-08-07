//
//  GetCurrentUserUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 06/08/25.
//

import Foundation
import RxSwift

protocol GetCurrentUserUseCaseProtocol {
    func execute() -> Observable<User?>
}

class GetCurrentUserUseCaseImpl: GetCurrentUserUseCaseProtocol {
    
    let repository: UserRepositoryProtocol
    
    init (repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> Observable<User?> {
        return repository.getCurrentUser()
    }
}
