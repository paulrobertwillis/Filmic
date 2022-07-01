//
//  GetTopRatedMoviesUseCaseTests.swift
//  MovieAppTests
//
//  Created by Paul on 27/06/2022.
//

import Foundation
import XCTest
@testable import MovieApp

class GetTopRatedMoviesUseCaseTests: XCTestCase {
    private var repository: MoviesRepositoryMock?
    private var sut: GetTopRatedMoviesUseCase?
    private var returnedMovies: [Movie]?
    
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
    
    // MARK: - Setup
    
    override func tearDown() {
        self.repository = nil
        self.sut = nil
        self.returnedMovies = nil
    }
    
    // MARK: - Tests
    
    func test_GetTopRatedMoviesUseCase_whenExecutes_shouldCallRepositoryOnce() {
        // given
        givenMoviesToBeFetched(movies: [])
        givenUseCaseIsInitialised()
        
        // when
        whenUseCaseRequestsMovies()

        // then
        thenEnsureRepositoryIsCalledExactlyOnce()
    }
    
    func test_GetTopRatedMoviesUseCase_shouldGetMoviesFromRepository() {
        // given
        givenMoviesToBeFetched(movies: self.movies)
        givenUseCaseIsInitialised()
             
        // when
        whenUseCaseRequestsMovies()
        
        // then
        thenEnsureMoviesAreFetched()
    }
    
    // MARK: - Given
    
    private func givenMoviesToBeFetched(movies: [Movie]) {
        self.repository = MoviesRepositoryMock()
        self.repository?.getMoviesReturnValue = movies
    }
    
    private func givenUseCaseIsInitialised() {
        self.sut = GetTopRatedMoviesUseCase(repository: repository!)
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
