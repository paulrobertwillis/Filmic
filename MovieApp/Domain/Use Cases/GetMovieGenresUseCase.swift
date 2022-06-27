//
//  GetMovieGenresUseCase.swift
//  MovieApp
//
//  Created by Paul on 21/06/2022.
//

import Foundation

protocol GetMovieGenresUseCaseProtocol {
    @discardableResult
    func execute(completion: @escaping (Result<[Genre], Error>) -> Void) -> URLSessionTask?
}

class GetMovieGenresUseCase: GetMovieGenresUseCaseProtocol {
    private let repository: GenresRepositoryProtocol
    
    init(repository: GenresRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    func execute(completion: @escaping (Result<[Genre], Error>) -> Void) -> URLSessionTask? {
        return self.repository.getMovieGenres { result in
            completion(result)
        }
    }
}
