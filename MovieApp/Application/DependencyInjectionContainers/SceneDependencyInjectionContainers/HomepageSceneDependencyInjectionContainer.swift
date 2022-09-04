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
    
    private func makeHomepageViewModel(actions: HomepageViewModelActions) -> HomepageViewModel {
        HomepageViewModel(actions: actions)
    }
    
    // MARK: - RecommendedMoviesCollection
    
    func makeHomepageViewController(actions: RecommendedMoviesCollectionViewModelActions) -> RecommendedMoviesCollectionViewController {
//        RecommendedMoviesCollectionViewController.create(with: self.makeRecommendedMoviesCollectionViewModel(actions: actions))
        RecommendedMoviesCollectionViewController()
    }
    
    private func makeRecommendedMoviesCollectionViewModel(actions: RecommendedMoviesCollectionViewModelActions) -> RecommendedMoviesCollectionViewModel {
        RecommendedMoviesCollectionViewModel(actions: actions)
    }

    
    // MARK: - Flow Coordinators
    
    func makeHomepageFlowCoordinator(navigationController: UINavigationController) -> HomepageFlowCoordinator {
        HomepageFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension HomepageSceneDependencyInjectionContainer: HomepageFlowCoordinatorDependencies {}
