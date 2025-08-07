//
//  LoginUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 06/08/25.
//

import Foundation
import RxSwift

protocol LoginUseCaseProtocol {
    func execute(id: String, password: String) -> Observable<User?>
}

final class LoginUseCaseImpl: LoginUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    let disposeBag = DisposeBag()
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: String, password: String) -> Observable<User?> {
        return repository.login(id: id, password: password)
    }
}
