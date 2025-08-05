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
    var coordinator: AppCoordinator?
    var navigationController: UINavigationController?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
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
    }
}
