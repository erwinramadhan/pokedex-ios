//
//  LoginView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import UIKit

class LoginView: UIViewController {

    @IBOutlet weak var formViewContainer: UIView!
    var viewModel: LoginViewModel!
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: LoginView.self), bundle: Bundle(for: LoginView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFormViewContriner()
    }
    
    private func setupFormViewContriner() {
        formViewContainer.layer.cornerRadius = 32
        formViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        formViewContainer.layer.masksToBounds = true
    }

}
