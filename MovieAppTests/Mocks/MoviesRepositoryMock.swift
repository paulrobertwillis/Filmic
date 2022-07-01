//
//  MoviesRepositoryMock.swift
//  MovieAppTests
//
//  Created by Paul on 01/07/2022.
//

import Foundation
@testable import MovieApp

class MoviesRepositoryMock: MoviesRepositoryProtocol {
    
    // MARK: - getMovies
    
    var getMoviesCallsCount = 0
    var getMoviesReturnValue: [Movie]! = []
    var getMoviesClosure: (() -> [Movie])?

    func getMovies() -> [Movie] {
        self.getMoviesCallsCount += 1

        return getMoviesClosure.map({ $0() }) ?? getMoviesReturnValue
    }
}
