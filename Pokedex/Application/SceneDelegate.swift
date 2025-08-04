//
//  SceneDelegate.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import UIKit
import netfox

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
//        let localDataSource = RealmAuthLocalDataSource()
//        let authRepo = AuthRepositoryImpl(localDataSource: localDataSource)
//        let useCase = AuthStateUseCase(repository: authRepo)
//        let diContainer = AppDIContainer()
//        
//        let rootVC: UIViewController
//        if useCase.isUserLoggedIn() {
//            let landingPagerTabStrip = LandingPagerTabStripViewModel()
//            let homeViewModel = diContainer.makeHomeViewModel()
//            let profileViewModel = ProfileViewModel()
//            rootVC = LandingPagerTabStrip(viewModel: landingPagerTabStrip, homeViewModel: homeViewModel, profileViewModel: profileViewModel)
//        } else {
////            let vm = LoginViewModel()
////            rootVC = LoginView(viewModel: vm)
//            
//            let landingPagerTabStrip = LandingPagerTabStripViewModel()
//            let homeViewModel = diContainer.makeHomeViewModel()
//            let profileViewModel = ProfileViewModel()
//            rootVC = LandingPagerTabStrip(viewModel: landingPagerTabStrip, homeViewModel: homeViewModel, profileViewModel: profileViewModel)
//        }
//        
//        NFX.sharedInstance().start()
//        window?.rootViewController = rootVC
//        window?.makeKeyAndVisible()
        
        let appDIContainer = AppDIContainer()
        let coordinator = AppCoordinator(window: window, appDIContainer: appDIContainer)
        
        coordinator.start()
        
        window.makeKeyAndVisible()
        
        NFX.sharedInstance().start()
    }
}
