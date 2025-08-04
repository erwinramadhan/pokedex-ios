//
//  RegisterView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import UIKit

class RegisterView: UIViewController {

    @IBOutlet weak var formViewContainer: UIView!
    var viewModel: RegisterViewModel!
    
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
    }
    
    private func setupUI() {
        setupFormViewContriner()
    }
    
    private func setupFormViewContriner() {
        formViewContainer.layer.cornerRadius = 32
        formViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        formViewContainer.layer.masksToBounds = true
    }

}
