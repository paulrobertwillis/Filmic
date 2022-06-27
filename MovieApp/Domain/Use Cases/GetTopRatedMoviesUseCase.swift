//
//  GetTopRatedMoviesUseCase.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

protocol GetTopRatedMoviesUseCaseProtocol {
}

class GetTopRatedMoviesUseCase: GetTopRatedMoviesUseCaseProtocol {
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    func execute() -> [Movie] {
        self.repository.getMovies()
    }
}
