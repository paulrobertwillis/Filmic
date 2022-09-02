//
//  HomepageSceneDependencyInjectionContainer.swift
//  MovieApp
//
//  Created by Paul on 02/09/2022.
//

import UIKit

class HomepageSceneDependencyInjectionContainer {
    
    struct Dependencies {
        
    }
    
    // MARK: - Private Properties
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    
    
    
    // MARK: - Repositories
    
    
    
    // MARK: - Homepage
    
    func makeHomepageViewController(actions: HomepageViewModelActions) -> HomepageViewController {
        HomepageViewController.create(with: self.makeHomepageViewModel(actions: actions))
    }
    
    func makeHomepageViewModel(actions: HomepageViewModelActions) -> HomepageViewModel {
        HomepageViewModel(actions: actions)
    }
    
    // MARK: - RecommendedMoviesCollection
    
    
    
    // MARK: - Flow Coordinators
    
    func makeHomepageFlowCoordinator(navigationController: UINavigationController) -> HomepageFlowCoordinator {
        HomepageFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension HomepageSceneDependencyInjectionContainer: HomepageFlowCoordinatorDependencies {}
