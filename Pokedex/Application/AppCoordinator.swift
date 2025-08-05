//
//  AppCoordinator.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

import UIKit

class AppCoordinator: AppCoordinatorProtocol {
    private let window: UIWindow
    private let appDIContainer: AppDIContainer
    private let navigationController: UINavigationController

    init(window: UIWindow, appDIContainer: AppDIContainer, navigationController: UINavigationController) {
        self.window = window
        self.appDIContainer = appDIContainer
        self.navigationController = navigationController
    }

    func start() {
        showLandingFlow()
    }
    
    // MARK: Show Flow
    private func showLoginFlow() {
        
    }

    private func showLandingFlow() {
        let initialViewController = createLandingPagerTabStripView()
        navigationController.pushViewController(initialViewController, animated: false)
    }
    
    // MARK: Creating View Controller
    private func createLandingPagerTabStripView() -> UIViewController {
        let landingPagerTabStripViewModel = LandingPagerTabStripViewModel()
        let homeView = createHomeView()
        homeView.navigateToDetail = { [weak self] pokemon in
            guard let self else { return }
            homeView.navigationController?.pushViewController(createDetailView(selectedPokemon: pokemon), animated: true)
        }
        
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
    
    private func createLoginView() -> LoginView {
        let loginViewModel = appDIContainer.makeLoginViewModel()
        let loginView = LoginView(viewModel: loginViewModel)
        return loginView
    }
    
    private func createRegisterView() -> RegisterView {
        let registerViewModel = appDIContainer.makeRegisterViewModel()
        let registerView = RegisterView(viewModel: registerViewModel)
        return registerView
    }
    
    private func createDetailView(selectedPokemon: PokemonListItem) -> DetailView {
        let detailViewModel = appDIContainer.makeDetailViewModel(selectedPokemon: selectedPokemon)
        let detailView = DetailView(viewModel: detailViewModel)
        return detailView
    }
}
