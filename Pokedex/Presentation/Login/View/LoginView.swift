//
//  LoginView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import UIKit
import RxSwift

class LoginView: UIViewController {
    
    @IBOutlet weak var formViewContainer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
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
    }
    
    private func setupFormViewContainer() {
        formViewContainer.layer.cornerRadius = 32
        formViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        formViewContainer.layer.masksToBounds = true
    }
    
    private func setupRegisterButton() {
        registerButton.addAction { [weak self] in
            self?.navigateToRegister?()
        }
    }
    
    private func setupLoginButton() {
        loginButton.addAction { [weak self] in
            guard let self else { return }
            viewModel.login()
        }
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
