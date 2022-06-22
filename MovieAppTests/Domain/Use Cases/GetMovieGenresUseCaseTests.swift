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
    var repository: MoviesRepositoryMock?
    var sut: GetMovieGenresUseCase?
    var returnedMovies: [Movie]?
    
    override func tearDown() {
        self.repository = nil
        self.sut = nil
        self.returnedMovies = nil
    }
    
    // MARK: - Tests
    
    func test_GetMovieGenresUseCase_whenExecutes_shouldCallRepositoryOnce() {
        // given
        givenMoviesToBeFetched(movies: [])
        givenUseCaseIsInitialised()
        
        // when
        whenUseCaseRequestsMovies()

        // then
        thenEnsureRepositoryIsCalledExactlyOnce()
    }
    
    func test_GetMovieGenresUseCase_shouldGetMoviesFromRepository() {
        // given
        givenMoviesToBeFetched(movies: self.movies)
        givenUseCaseIsInitialised()
             
        // when
        whenUseCaseRequestsMovies()
        
        // then
        thenEnsureMoviesAreFetched()
    }
    
    private let movies = [
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

    // MARK: - Given
    
    private func givenMoviesToBeFetched(movies: [Movie]) {
        self.repository = MoviesRepositoryMock()
        self.repository?.getMoviesReturnValue = movies
    }
    
    private func givenUseCaseIsInitialised() {
        self.sut = GetMovieGenresUseCase(repository: repository!)
    }
    
    // MARK: - When
    
    private func whenUseCaseRequestsMovies() {
        self.returnedMovies = self.sut?.execute()
    }
    
    // MARK: - Then
    
    private func thenEnsureRepositoryIsCalledExactlyOnce() {
        XCTAssertEqual(self.repository?.getMoviesCallsCount, 1)
    }
    
    private func thenEnsureMoviesAreFetched() {
        XCTAssertEqual(self.movies, self.returnedMovies)
    }
}

class MoviesRepositoryMock: MoviesRepositoryProtocol {
    
    // MARK: - getMovies
    
    var getMoviesCallsCount = 0
    var getMoviesReturnValue: [Movie]!
    var getMoviesClosure: (() -> [Movie])?

    func getMovies() -> [Movie] {
        self.getMoviesCallsCount += 1

        return getMoviesClosure.map({ $0() }) ?? getMoviesReturnValue
    }
}
