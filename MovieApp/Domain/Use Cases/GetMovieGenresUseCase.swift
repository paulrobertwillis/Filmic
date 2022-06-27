//
//  GetMovieGenresUseCase.swift
//  MovieApp
//
//  Created by Paul on 21/06/2022.
//

import Foundation

protocol GetMovieGenresUseCaseProtocol {
    @discardableResult
    func execute(completion: (Result<[Genre], Error>) -> Void) -> URLSessionTask?
}

class GetMovieGenresUseCase: GetMovieGenresUseCaseProtocol {
    private let repository: GenresRepositoryProtocol
    
    init(repository: GenresRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    func execute(completion: (Result<[Genre], Error>) -> Void) -> URLSessionTask? {
        completion(self.repository.getMovieGenres())
        return nil
    }
}
