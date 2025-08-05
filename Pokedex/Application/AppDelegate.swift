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
    var navigationController: UINavigationController?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let appDIContainer = AppDIContainer()
        navigationController = UINavigationController()
        navigationController?.navigationBar.isHidden = true
        coordinator = AppCoordinator(window: window,
                                     appDIContainer: appDIContainer,
                                     navigationController: navigationController ?? UINavigationController()
        )
        
        coordinator?.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        NFX.sharedInstance().start()
        
        return true
    }
}
