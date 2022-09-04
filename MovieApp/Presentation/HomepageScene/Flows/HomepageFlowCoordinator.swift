//
//  HomepageFlowCoordinator.swift
//  MovieApp
//
//  Created by Paul on 02/09/2022.
//

import UIKit

// TODO: Potentially create a dependencies protocol and a flow coordinator protocol that includes basic structure of this file?

protocol HomepageFlowCoordinatorDependencies {
    func makeHomepageViewController(actions: HomepageViewModelActions) -> HomepageViewController
}

class HomepageFlowCoordinator: CoordinatorProtocol {
    
    // MARK: - Public Properties
    
    var childCoordinators = [CoordinatorProtocol]()
    let navigationController: UINavigationController
    
    // MARK: - Private Properties
        
    private let dependencies: HomepageFlowCoordinatorDependencies
    
    private weak var homepageViewController: HomepageViewController?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController,
         dependencies: HomepageFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = HomepageViewModelActions()
        let viewController = self.dependencies.makeHomepageViewController(actions: actions)
        
        self.navigationController.pushViewController(viewController, animated: false)
        self.homepageViewController = viewController
    }
}
