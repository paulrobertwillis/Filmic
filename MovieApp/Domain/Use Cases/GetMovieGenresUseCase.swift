//
//  GetMovieGenresUseCase.swift
//  MovieApp
//
//  Created by Paul on 21/06/2022.
//

import Foundation

protocol GetMovieGenresUseCaseProtocol {
    typealias ResultValue = (Result<[Genre], Error>)
    typealias CompletionHandler = (ResultValue) -> Void

    @discardableResult
    func execute(completion: @escaping CompletionHandler) -> URLSessionTask?
}

class GetMovieGenresUseCase {
    
    // MARK: - Private Properties
    
    private let repository: GenresRepositoryProtocol
    
    // MARK: - Lifecycle
    
    init(repository: GenresRepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - GetMovieGenresUseCaseProtocol

extension GetMovieGenresUseCase: GetMovieGenresUseCaseProtocol {
    @discardableResult
    func execute(completion: @escaping CompletionHandler) -> URLSessionTask? {
        self.repository.getMovieGenres { result in
            completion(result)
        }
        return URLSessionTask()
    }
}
