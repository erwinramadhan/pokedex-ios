//
//  AppCoordinator.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

import UIKit
import RxSwift

class AppCoordinator: AppCoordinatorProtocol {
    private let window: UIWindow
    private let appDIContainer: AppDIContainer
    private let navigationController: UINavigationController
    private let userRepository: UserRepositoryProtocol
    
    let disposeBag = DisposeBag()
    
    init(window: UIWindow, appDIContainer: AppDIContainer, navigationController: UINavigationController) {
        self.window = window
        self.appDIContainer = appDIContainer
        self.navigationController = navigationController
        self.userRepository = appDIContainer.makeUserRepository()
    }
    
    func start() {
        if let user = userRepository.getCurrentUser() {
            print("✅ Logged in as: \(user.name)")
            showLandingFlow()
        } else {
            print("🔒 No user logged in")
            showLoginFlow()
        }
    }
    
    // MARK: Show Flow
    private func showLoginFlow() {
        replaceToLoginView()
    }

    private func showLandingFlow() {
        replaceToLandingView()
    }
    
    // MARK: Creating View Controller
    private func createLandingPagerTabStripView() -> UIViewController {
        let landingPagerTabStripViewModel = LandingPagerTabStripViewModel()
        let homeView = createHomeView()
        homeView.navigateToDetail = { [weak self] pokemon in
            self?.navigateToDetail(pokemon: pokemon)
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
        loginView.navigateToRegister = { [weak self] in
            self?.replaceToRegister()
        }
        loginView.navigateToLanding = { [weak self] in
            self?.replaceToLandingView()
        }
        return loginView
    }
    
    private func createRegisterView() -> RegisterView {
        let registerViewModel = appDIContainer.makeRegisterViewModel()
        let registerView = RegisterView(viewModel: registerViewModel)
        
        registerView.navigateToHome = { [weak self] in
            self?.replaceToLandingView()
        }
        registerView.navigateToLogin = { [weak self] in
            self?.replaceToLoginView()
        }
        return registerView
    }
    
    private func createDetailView(selectedPokemon: PokemonListItem) -> DetailView {
        let detailViewModel = appDIContainer.makeDetailViewModel(selectedPokemon: selectedPokemon)
        let detailView = DetailView(viewModel: detailViewModel)
        return detailView
    }
    
    // MARK: Navigation Controller Manipulation
    private func replaceToRegister() {
        let registerView = createRegisterView()
        navigationController.setViewControllers([registerView], animated: true)
    }
    
    private func replaceToLoginView() {
        let loginView = createLoginView()
        navigationController.setViewControllers([loginView], animated: true)
    }
    
    private func replaceToLandingView() {
        let initialViewController = createLandingPagerTabStripView()
        navigationController.setViewControllers([initialViewController], animated: true)
    }
    
    private func navigateToDetail(pokemon: PokemonListItem) {
        let detailView = createDetailView(selectedPokemon: pokemon)
        navigationController.pushViewController(detailView, animated: true)
    }
    
}
