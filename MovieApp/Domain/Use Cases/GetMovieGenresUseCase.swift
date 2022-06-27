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

class GetMovieGenresUseCase: GetMovieGenresUseCaseProtocol {
    private let repository: GenresRepositoryProtocol
    
    init(repository: GenresRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    func execute(completion: @escaping CompletionHandler) -> URLSessionTask? {
        self.repository.getMovieGenres { result in
            completion(result)
        }
        return URLSessionTask()
    }
}
