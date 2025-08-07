//
//  LoginView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import UIKit
import RxSwift
import RxCocoa

class LoginView: UIViewController {
    
    @IBOutlet weak var formViewContainer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var trainerIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel: LoginViewModel!
    let disposeBag = DisposeBag()
    
    // MARK: Navigation Callback Closure
    var navigateToRegister: (() -> Void)?
    var navigateToLanding: (() -> Void)?
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: LoginView.self), bundle: Bundle(for: LoginView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObserveVM()
        setupFormViewContainer()
        setupRegisterButton()
        setupLoginButton()
        setupBindingTextFieldToVM()
    }
    
    private func setupBindingTextFieldToVM() {
        trainerIDTextField.rx.text
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.trainerID.accept(text ?? "")
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.password.accept(text ?? "")
            })
            .disposed(by: disposeBag)
    }
    
    private func setupFormViewContainer() {
        formViewContainer.layer.cornerRadius = 32
        formViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        formViewContainer.layer.masksToBounds = true
    }
    
    private func setupRegisterButton() {
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToRegister?()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLoginButton() {
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.login()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupObserveVM() {
        viewModel.isSuccessLoginObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isSuccess in
                self?.navigateToLanding?()
            })
            .disposed(by: disposeBag)
    }
    
}
