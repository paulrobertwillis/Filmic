//
//  GetTopRatedMoviesUseCase.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

protocol GetTopRatedMoviesUseCaseProtocol {
    typealias ResultValue = (Result<MoviesPage, Error>)
    typealias CompletionHandler = (ResultValue) -> Void

    @discardableResult
    func execute(completion: @escaping CompletionHandler) -> URLSessionTask?
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
    func execute(completion: @escaping CompletionHandler) -> URLSessionTask? {
        self.repository.getMovies { result in
            completion(result)
        }
        return URLSessionTask()
    }
}
