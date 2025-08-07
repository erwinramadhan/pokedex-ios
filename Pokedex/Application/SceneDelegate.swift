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

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true

        let appDIContainer = AppDIContainer()
        let coordinator = AppCoordinator(
            window: window,
            appDIContainer: appDIContainer,
            navigationController: navigationController
        )

        self.window = window
        self.coordinator = coordinator

        coordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        // Start network debug tool
        NFX.sharedInstance().start()
    }
}
