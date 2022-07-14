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
        let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=87c18a6eca3e6995e82fab7f60b9a8a7&language=en-US")!)

        
        self.repository.getMovieGenres(request: request) { result in
            completion(result)
        }
        
        return URLSessionTask()
    }
}
