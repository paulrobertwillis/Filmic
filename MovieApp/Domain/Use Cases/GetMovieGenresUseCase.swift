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
    private let repository: GenresRepositoryProtocol
    
    init(repository: GenresRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    func execute() -> [Genre] {
        self.repository.getMovieGenres()
    }
}
