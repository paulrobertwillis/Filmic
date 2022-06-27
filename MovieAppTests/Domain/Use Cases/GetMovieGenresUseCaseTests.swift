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
    private var repository: GenresRepositoryMock?
    private var sut: GetMovieGenresUseCase?
    private var returnedGenres: [Genre]?
    
    private let genres = [
        Genre(id: Genre.Identifier(50), name: "Genre1"),
        Genre(id: Genre.Identifier(100), name: "Genre2"),
    ]
    
    // MARK: - Setup
    
    override func tearDown() {
        self.repository = nil
        self.sut = nil
        self.returnedGenres = nil
    }

    // MARK: - Tests
    
    func test_GetMovieGenresUseCase_whenExecutes_shouldCallRepositoryOnce() {
        // given
        givenGenresToBeFetched(genres: [])
        givenUseCaseIsInitialised()
        
        // when
        whenUseCaseRequestsGenres()

        // then
        thenEnsureRepositoryIsCalledExactlyOnce()
    }
    
    func test_GetTopRatedMoviesUseCase_whenExecutes_shouldGetGenresFromRepository() {
        // given
        givenGenresToBeFetched(genres: self.genres)
        givenUseCaseIsInitialised()
             
        // when
        whenUseCaseRequestsGenres()
        
        // then
        thenEnsureGenresAreFetched()
    }
    
    // MARK: - Given
    
    private func givenGenresToBeFetched(genres: [Genre]) {
        self.repository = GenresRepositoryMock()
        self.repository?.getMovieGenresReturnValue = genres
    }
    
    private func givenUseCaseIsInitialised() {
        self.sut = GetMovieGenresUseCase(repository: repository!)
    }
    
    // MARK: - When
    
    private func whenUseCaseRequestsGenres() {
        self.returnedGenres = try? self.sut?.execute().get()
    }
    
    // MARK: - Then
    
    private func thenEnsureRepositoryIsCalledExactlyOnce() {
        XCTAssertEqual(self.repository?.getMovieGenresCallsCount, 1)
    }
    
    private func thenEnsureGenresAreFetched() {
        XCTAssertEqual(self.genres, self.returnedGenres)
    }
}

private class GenresRepositoryMock: GenresRepositoryProtocol {
    
    // MARK: - getMovieGenres
    
    var getMovieGenresCallsCount = 0
    var getMovieGenresReturnValue: [Genre]! = []
    var getMovieGenresClosure: (() -> [Genre])?

    func getMovieGenres() -> Result<[Genre], Error> {
        self.getMovieGenresCallsCount += 1
        
        return.success(getMovieGenresClosure.map({ $0() }) ?? getMovieGenresReturnValue)
    }
}
