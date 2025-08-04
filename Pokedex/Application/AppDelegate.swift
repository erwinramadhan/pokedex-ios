//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import UIKit
import netfox

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
//        let localDataSource = RealmAuthLocalDataSource()
//        let authRepo = AuthRepositoryImpl(localDataSource: localDataSource)
//        let useCase = AuthStateUseCase(repository: authRepo)
        let appDIContainer = AppDIContainer()
        
//        let rootVC: UIViewController
//        if useCase.isUserLoggedIn() {
//            let landingPagerTabStrip = LandingPagerTabStripViewModel()
//            let homeViewModel = diContainer.makeHomeViewModel()
//            let profileViewModel = ProfileViewModel()
//            rootVC = LandingPagerTabStrip(viewModel: landingPagerTabStrip, homeViewModel: homeViewModel, profileViewModel: profileViewModel)
//            
//        } else {
//            let vm = LoginViewModel()
//            rootVC = LoginView(viewModel: vm)
//        }
        
        let coordinator = AppCoordinator(window: window, appDIContainer: appDIContainer)
        coordinator.start()
        window.makeKeyAndVisible()
        
        NFX.sharedInstance().start()
        
        return true
    }
}
