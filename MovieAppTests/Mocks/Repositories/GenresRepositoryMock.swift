//
//  GenresRepositoryMock.swift
//  MovieAppTests
//
//  Created by Paul on 01/07/2022.
//

import Foundation
@testable import MovieApp

class GenresRepositoryMock: GenresRepositoryProtocol {
    
    // MARK: - getMovieGenres
    
    var getMovieGenresCallsCount = 0
    var getMovieGenresReturnValue: URLSessionTask?
    var getMovieGenresClosure: ((CompletionHandler) -> URLSessionTask)?
    
    // completion parameter
    var getMovieGenresCompletionReturnValue: ResultValue? = .success([])
    var getMovieGenresReceivedCompletion: CompletionHandler? = { _ in }
    
    func getMovieGenres(completion: @escaping CompletionHandler) -> URLSessionTask? {
        self.getMovieGenresCallsCount += 1

        self.getMovieGenresReceivedCompletion = completion
        completion(getMovieGenresCompletionReturnValue!)
        
        return getMovieGenresClosure.map({ $0(completion) }) ?? getMovieGenresReturnValue
    }
}
