//
//  GetMovieGenresUseCase.swift
//  MovieApp
//
//  Created by Paul on 21/06/2022.
//

import Foundation

protocol GetMovieGenresUseCaseProtocol {
}

class GetMovieGenresUseCase: GetMovieGenresUseCaseProtocol {
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    func execute() -> [Movie] {
        self.repository.getMovies()
    }
}
