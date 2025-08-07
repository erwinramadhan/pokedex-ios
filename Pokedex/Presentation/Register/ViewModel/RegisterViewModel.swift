//
//  RegisterViewModel.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel: AnyObject {
    
    let trainerIdValue = BehaviorRelay<String>(value: "")
    let nameValue = BehaviorRelay<String>(value: "")
    let passwordValue = BehaviorRelay<String>(value: "")
    let confirmPasswordValue = BehaviorRelay<String>(value: "")
    
    let isRegisterEnabled: Observable<Bool>
    let registerResult = PublishSubject<Bool>()
    
    private let registerUserUseCase: RegisterUserUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(registerUserUseCase: RegisterUserUseCaseProtocol) {
        self.registerUserUseCase = registerUserUseCase
        
        isRegisterEnabled = Observable.combineLatest(
            trainerIdValue.asObservable(),
            nameValue.asObservable(),
            passwordValue.asObservable(),
            confirmPasswordValue.asObservable()
        )
        .map { trainerId, name, password, confirmPassword in
            return !trainerId.isEmpty &&
            !name.isEmpty &&
            !password.isEmpty &&
            password == confirmPassword &&
            password.count >= 6
        }
        .distinctUntilChanged()
    }
    
    func register() {
        let hasher = PasswordHasher()
        guard let hashedPassword = hasher.hash(password: passwordValue.value) else { return }
        
        let id = trainerIdValue.value
        let name = nameValue.value
        let user = User(id: id,
                        name: name,
                        password:  hashedPassword,
                        favorites: [])
        
        registerUserUseCase.execute(user: user)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] in
                    self?.registerResult.onNext(true)
                },
                onError: { [weak self] error in
                    self?.registerResult.onNext(false)
                }
            )
            .disposed(by: disposeBag)
        
    }
    
}
