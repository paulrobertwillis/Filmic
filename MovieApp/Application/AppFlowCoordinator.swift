//
//  AppFlowCoordinator.swift
//  MovieApp
//
//  Created by Paul on 02/09/2022.
//

import UIKit

protocol CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
}

class AppFlowCoordinator: CoordinatorProtocol {
    
    // MARK: - Public Properties
    
    var childCoordinators = [CoordinatorProtocol]()
    let navigationController: UINavigationController
    
    // MARK: - Private Properties
    
    private let appDIContainer: AppDependencyInjectionContainerProtocol
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, appDependencyInjectionContainer: AppDependencyInjectionContainerProtocol) {
        self.navigationController = navigationController
        self.appDIContainer = appDependencyInjectionContainer
    }
    
    // MARK: - API
    
    func start() {
        let homepageSceneDIContainer = self.appDIContainer.makeHomepageSceneDependencyInjectionContainer()
        let flowCoordinator = homepageSceneDIContainer.makeHomepageFlowCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(flowCoordinator)
        
        flowCoordinator.start()
    }
}
