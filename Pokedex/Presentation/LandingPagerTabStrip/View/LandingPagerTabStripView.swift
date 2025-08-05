//
//  LandingPagerTabStripView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import XLPagerTabStrip

class LandingPagerTabStrip: ButtonBarPagerTabStripViewController {
    
    var viewModel: LandingPagerTabStripViewModel!
    var homeView: HomeView?
    var profileView: ProfileView?
    
    init(viewModel: LandingPagerTabStripViewModel, homeView: HomeView, profileView: ProfileView) {
        self.viewModel = viewModel
        self.homeView = homeView
        self.profileView = profileView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let homeView, let profileView else {
            return []
        }
        return [homeView, profileView]
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(hex: "DC0A2D", alpha: 1.0)
        settings.style.buttonBarBackgroundColor =  UIColor(hex: "DC0A2D", alpha: 1.0)
        settings.style.buttonBarItemBackgroundColor = UIColor(hex: "DC0A2D", alpha: 1.0)
        settings.style.selectedBarBackgroundColor = UIColor(hex: "28AAFD", alpha: 1.0)
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 3.0
        
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        buttonBarView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonBarView.heightAnchor.constraint(equalToConstant: 44),

            containerView.topAnchor.constraint(equalTo: buttonBarView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
