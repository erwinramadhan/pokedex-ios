//
//  AppCoordinator.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

import UIKit

final class AppCoordinator: AppCoordinatorProtocol {
    private let window: UIWindow
    private let appDIContainer: AppDIContainer

    init(window: UIWindow, appDIContainer: AppDIContainer) {
        self.window = window
        self.appDIContainer = appDIContainer
    }

    func start() {
        let initialViewController = createLandingPagerTabStripView()
        window.rootViewController = initialViewController
    }
    
    // MARK: Creating Flow
    private func showLoginFlow() {
        
    }

    private func showLandingFlow() {
        let initialViewController = createLandingPagerTabStripView()
        window.rootViewController = initialViewController
    }
    
    // MARK: Creating View Controller
    private func createLandingPagerTabStripView() -> UIViewController {
        let landingPagerTabStripViewModel = LandingPagerTabStripViewModel()
        let homeView = createHomeView()
        let profileView = createProfileView()
        return LandingPagerTabStrip(viewModel: landingPagerTabStripViewModel, homeView: homeView, profileView: profileView)
    }
    
    private func createHomeView() -> HomeView {
        let homeViewModel = appDIContainer.makeHomeViewModel()
        let homeView = HomeView(viewModel: homeViewModel)
        return homeView
    }
    
    private func createProfileView() -> ProfileView {
        let profileViewModel = appDIContainer.makeProfileViewModel()
        let profileView = ProfileView(viewModel: profileViewModel)
        return profileView
    }
}
