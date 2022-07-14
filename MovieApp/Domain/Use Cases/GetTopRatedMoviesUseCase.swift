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
        let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=87c18a6eca3e6995e82fab7f60b9a8a7&language=en-US")!)
        
        self.repository.getMovies(request: request) { result in
            completion(result)
        }
        return URLSessionTask()
    }
}
