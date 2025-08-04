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
    
    // MARK: - Output
    var isLoginEnabled: Observable<Bool> {
        return Observable.combineLatest(trainerID, password)
            .map { !$0.isEmpty && !$1.isEmpty }
            .distinctUntilChanged()
    }
    
    let loginResult = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Actions
    func login() {
        let user = trainerID.value
        let pass = password.value
        
        if user == "admin" && pass == "password" {
            loginResult.onNext("Login successful")
        } else {
            loginResult.onNext("Invalid credentials")
        }
    }
    
}
