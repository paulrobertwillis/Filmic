//
//  GetTopRatedMoviesUseCase.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

protocol GetTopRatedMoviesUseCaseProtocol {
}

class GetTopRatedMoviesUseCase {
    
    // MARK: - Private Properties
    
    private let repository: MoviesRepositoryProtocol
    
    // MARK: - Lifecycle
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - GetTopRatedMoviesUseCaseProtocol {

extension GetTopRatedMoviesUseCase: GetTopRatedMoviesUseCaseProtocol {
    @discardableResult
    func execute() -> [Movie] {
        self.repository.getMovies()
    }
}
