//
//  AppFlowCoordinator.swift
//  MovieApp
//
//  Created by Paul on 02/09/2022.
//

import UIKit

class AppFlowCoordinator {
    
    // MARK: - Public Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Private Properties
    
    private let appDIContainer: AppDependencyInjectionContainer
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, appDependencyInjectionContainer: AppDependencyInjectionContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDependencyInjectionContainer
    }
    
    // MARK: - API
    
    func start() {
        let homepageSceneDIContainer = self.appDIContainer.makeHomepageSceneDependencyInjectionContainer()
        let flowCoordinator = homepageSceneDIContainer.makeHomepageFlowCoordinator(navigationController: self.navigationController)
        
        flowCoordinator.start()
    }
}
