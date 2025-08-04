//
//  ProfileView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import UIKit
import XLPagerTabStrip

class ProfileView: UIViewController {
    
    var viewModel: ProfileViewModel!
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ProfileView.self), bundle: Bundle(for: ProfileView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ProfileView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Profile")
    }
}
