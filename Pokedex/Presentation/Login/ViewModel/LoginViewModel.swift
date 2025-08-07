//
//  LoginViewModel.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    // MARK: - Input
    let trainerID = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let isSuccessLogin = PublishRelay<Bool>()
    let errorMessage = PublishRelay<String>()
    
    private let loginUseCase: LoginUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Output
    var isLoginEnabled: Observable<Bool> {
        return Observable.combineLatest(trainerID, password)
            .map { !$0.isEmpty && !$1.isEmpty }
            .distinctUntilChanged()
    }
    var isSuccessLoginObservable: Observable<Bool> {
        return isSuccessLogin.asObservable()
    }
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    // MARK: - Actions
    func login() {
        let id = trainerID.value
        let pw = password.value
        
        loginUseCase.execute(id: id, password: pw)
            .subscribe(
                onNext: { [weak self] user in
                    guard let self else { return }
                    if let user {
                        print("LOGIN SUCCESS", user)
                        print("userid", user.id, user.name)
                        UserDefaults.standard.set(user.id, forKey: "currentUserId")
                        isSuccessLogin.accept(true)
                    } else {
                        print("LOGIN FAILED")
                        isSuccessLogin.accept(false)
                    }
                },
                onError: { [weak self] error in
                    guard let self else { return }
                    print("error.localizedDescription", error.localizedDescription)
                    errorMessage.accept(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
}
