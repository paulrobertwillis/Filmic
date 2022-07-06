//
//  MoviesRepositoryMock.swift
//  MovieAppTests
//
//  Created by Paul on 01/07/2022.
//

import Foundation
@testable import MovieApp

class MoviesRepositoryMock: MoviesRepositoryProtocol {
    
    enum MoviesRepositoryMockError: Error {
        case failedFetching
    }
    
    // MARK: - getMovies
    
    var getMoviesCallsCount = 0
    var getMoviesReturnValue: URLSessionTask?

    // completion parameter
    var getMoviesCompletionReturnValue: ResultValue? = .failure(MoviesRepositoryMockError.failedFetching)
    var getMoviesReceivedCompletion: CompletionHandler? = { _ in }

    func getMovies(completion: @escaping CompletionHandler) -> URLSessionTask? {
        self.getMoviesCallsCount += 1
        
        self.getMoviesReceivedCompletion = completion
        completion(getMoviesCompletionReturnValue!)

        return getMoviesReturnValue
    }

}
