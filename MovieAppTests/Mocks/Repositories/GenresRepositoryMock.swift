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
    
    // request parameter
    var getMovieGenresReceivedRequest: URLRequest?
    
    // completion parameter
    var getMovieGenresCompletionReturnValue: ResultValue? = .success([])
    var getMovieGenresReceivedCompletion: CompletionHandler? = { _ in }
    
    func getMovieGenres(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
        self.getMovieGenresCallsCount += 1

        self.getMovieGenresReceivedRequest = request
        self.getMovieGenresReceivedCompletion = completion
        
        if let getMovieGenresCompletionReturnValue = getMovieGenresCompletionReturnValue {
            completion(getMovieGenresCompletionReturnValue)
        }
        
        return getMovieGenresClosure.map({ $0(completion) }) ?? getMovieGenresReturnValue
    }
}
