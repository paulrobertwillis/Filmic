//
//  RecommendedMoviesCollectionViewModel.swift
//  MovieApp
//
//  Created by Paul on 02/09/2022.
//

import Foundation

struct RecommendedMoviesCollectionViewModelActions {
    
}

protocol RecommendedMoviesCollectionViewModelProtocol {
    
}

class RecommendedMoviesCollectionViewModel: RecommendedMoviesCollectionViewModelProtocol {
    
    // MARK: - Private Properties
    
    private let actions: RecommendedMoviesCollectionViewModelActions
    
    // MARK: - Init
    
    init(actions: RecommendedMoviesCollectionViewModelActions) {
        self.actions = actions
    }
    
}
