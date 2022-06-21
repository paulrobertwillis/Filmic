//
//  GetMovieGenresUseCase.swift
//  MovieApp
//
//  Created by Paul on 21/06/2022.
//

import Foundation

protocol MoviesRepositoryProtocol {
    func getMovies() -> [Movie]
}

protocol GetMoviesGenresUseCaseProtocol {
}

class GetMovieGenresUseCase {
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    func execute() -> [Movie] {
        self.repository.getMovies()
    }
}
