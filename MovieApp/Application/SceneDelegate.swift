//
//  SceneDelegate.swift
//  MovieApp
//
//  Created by Paul on 12/06/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Public Properties
    
    var window: UIWindow?

    // MARK: - Private Properties
    
    private let appDependencyInjectionContainer = AppDependencyInjectionContainer()
    private var appFlowCoordinator: CoordinatorProtocol?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        
        self.window?.rootViewController = navigationController
        
        self.appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDependencyInjectionContainer: self.appDependencyInjectionContainer
        )
        self.appFlowCoordinator?.start()
        
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataStorage.shared.saveContext()
    }
}

