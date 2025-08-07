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
    var coordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        
        let appDIContainer = AppDIContainer()
        let coordinator = AppCoordinator(
            window: window,
            appDIContainer: appDIContainer,
            navigationController: navigationController
        )
        
        self.coordinator = coordinator
        coordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Start network debug tool
        NFX.sharedInstance().start()
        
        return true
    }
}

