//
//  GetMovieGenresUseCaseTests.swift
//  MovieAppTests
//
//  Created by Paul on 21/06/2022.
//

import Foundation
import XCTest
@testable import MovieApp

class GetMovieGenresUseCaseTests: XCTestCase {
    
    
    func test_GetMovieGenresUseCase_whenExecutes_shouldCallRepository() {
        let repository = MoviesRepositorySpy()
        let sut = GetMovieGenresUseCase(repository: repository)
        
        sut.execute()
        
        XCTAssertEqual(repository.getMoviesCallsCount, 1)
    }
    
    func test_GetMovieGenresUseCase_shouldGetMoviesFromRepository() {
        let repository = MoviesRepositorySpy()
        let sut = GetMovieGenresUseCase(repository: repository)
        
        let returnedMovies = sut.execute()
        
        XCTAssertEqual(movies, returnedMovies)
    }
    
    let movies = [
        Movie(
            id: Movie.Identifier(50),
            title: "movie1",
            posterPath: "/posterpath1.jpg",
            overview: "movie1 overview",
            releaseDate: "2001-01-01"
        ),
        Movie(
            id: Movie.Identifier(100),
            title: "movie2",
            posterPath: "/posterpath2.jpg",
            overview: "movie2 overview",
            releaseDate: "2002-01-01"
        )
    ]

    
    class MoviesRepositorySpy: MoviesRepositoryProtocol {
        
        // MARK: - getMovies
        
        var getMoviesCallsCount = 0
        
        func getMovies() -> [Movie] {
            self.getMoviesCallsCount += 1
            return []
        }
    }
}

//    var <#noParam#>CallsCount = 0
//    var <#noParam#>Called: Bool {
//        return <#noParam#>CallsCount > 0
//    }
//
//    /// Create a stubbed return value for the function
//    var <#noParam#>ReturnValue: Int!
//    /// Create a mock implementation of the function
//    var <#noParam#>Closure: (() -> Int)?
//
//    func <#noParam#>() -> Int {
//        <#noParam#>CallsCount += 1
//
//        return <#noParam#>Closure.map({ $0() }) ?? <#noParam#>ReturnValue
//    }

