//
//  RegisterView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import UIKit
import RxCocoa
import RxSwift

class RegisterView: UIViewController {
    
    @IBOutlet weak var formViewContainer: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var trainerIDTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    
    // MARK: Navigation Callback Closure
    var navigateToLogin: (() -> Void)?
    var navigateToHome: (() -> Void)?
    
    var viewModel: RegisterViewModel!
    
    let disposeBag = DisposeBag()
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: RegisterView.self), bundle: Bundle(for: RegisterView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindingVM()
    }
    
    private func setupUI() {
        setupFormViewContriner()
        setupLoginButton()
    }
    
    private func setupLoginButton() {
//        loginButton.rx.controlEvent(.touchUpInside)
//            .subscribe(onNext: { [weak self] _ in
//                self?.navigateLoginSubject.onNext(())
//            })
//            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                navigateToLogin?()
            }
            .disposed(by: disposeBag)
        
        registerButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.register()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupFormViewContriner() {
        formViewContainer.layer.cornerRadius = 32
        formViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        formViewContainer.layer.masksToBounds = true
    }
    
    private func bindingVM() {
        trainerIDTextfield.rx.text.orEmpty
            .bind(to: viewModel.trainerIdValue)
            .disposed(by: disposeBag)
        
        nameTextfield.rx.text.orEmpty
            .bind(to: viewModel.nameValue)
            .disposed(by: disposeBag)
        
        passwordTextfield.rx.text.orEmpty
            .bind(to: viewModel.passwordValue)
            .disposed(by: disposeBag)
        
        confirmPasswordTextfield.rx.text.orEmpty
            .bind(to: viewModel.confirmPasswordValue)
            .disposed(by: disposeBag)
        
        viewModel.isRegisterEnabled
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                registerButton.isEnabled = isEnabled
                
                if #available(iOS 15.0, *) {
                    var config = UIButton.Configuration.filled()
                    
                    config.baseBackgroundColor = UIColor(hex: "DC0A2D", alpha: 1.0)
                    
                    registerButton.configuration = config
                } else {
                    registerButton.backgroundColor = isEnabled ? UIColor(hex: "DC0A2D", alpha: 1.0) : .darkGray
                    registerButton.setTitleColor(isEnabled ? .white : .lightGray, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.registerResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                navigateToHome?()
            })
            .disposed(by: disposeBag)
    }
    
}
