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
    private var resultValue: MoviesRepositoryProtocol.ResultValue?
    private var returnedMoviePage: MoviesPage?
    private var task: URLSessionTask?
    
    private let moviesPage = MoviesPage(
                                    page: 1,
                                    totalPages: 1,
                                    movies: [
                                        Movie(
                                            adult: false,
                                            backdropPath: "/movieBackdropPath",
                                            budget: 5000,
                                            genres: [],
                                            homepage: "/movieHomepage",
                                            id: Movie.Identifier(50),
                                            imdbId: "9",
                                            originalLanguage: "French",
                                            originalTitle: "LeMovie",
                                            overview: "movie1 overview",
                                            popularity: 50.99,
                                            posterPath: "/posterpath1.jpg",
                                            releaseDate: "2001-01-01",
                                            revenue: 20,
                                            runtime: 90,
                                            status: "Released",
                                            tagline: "Gonna Be Good",
                                            title: "movie1",
                                            video: false,
                                            voteAverage: 3.3,
                                            voteCount: 9008
                                            )
                                        ]
                                    )
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        self.repository = MoviesRepositoryMock()
        self.sut = GetTopRatedMoviesUseCase(repository: repository!)
    }
    
    override func tearDown() {
        self.repository = nil
        self.sut = nil
        self.resultValue = nil
        self.returnedMoviePage = nil
        self.task = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_GetTopRatedMoviesUseCase_whenExecutes_shouldCallRepositoryOnce() {
        // when
        whenUseCaseRequestsMovies()

        // then
        thenEnsureRepositoryIsCalledExactlyOnce()
    }
    
    func test_GetTopRatedMoviesUseCase_whenPerformsSuccessfulRequest_shouldGetMoviePageFromRepository() {
        // given
        givenExpectedSuccess()

        // when
        whenUseCaseRequestsMovies()
        
        // then
        thenEnsureMoviePageIsFetched()
    }
    
    // MARK: - Given
        
    private func givenExpectedSuccess() {
        self.repository?.getMoviesCompletionReturnValue = .success(self.moviesPage)
    }
        
    // MARK: - When
    
    private func whenUseCaseRequestsMovies() {
        self.task = self.sut?.execute { result in
            self.resultValue = result
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureRepositoryIsCalledExactlyOnce() {
        XCTAssertEqual(self.repository?.getMoviesCallsCount, 1)
    }
    
    private func thenEnsureMoviePageIsFetched() {
        let returnedMoviesPage = try? unwrapResult()
        XCTAssertEqual(self.moviesPage, returnedMoviesPage)
    }
    
    // MARK: - Helpers
    
    private func unwrapResult() throws -> MoviesPage? {
        return try self.resultValue?.get()
    }
}
