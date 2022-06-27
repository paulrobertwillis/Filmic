//
//  GenresRepository.swift
//  MovieAppTests
//
//  Created by Paul on 27/06/2022.
//

import Foundation
import XCTest
@testable import MovieApp

class GenresRepositoryTests: XCTestCase {
    
    enum GenresRepositorySuccessTestError: Error {
        case failedFetching
    }
        
    func test_GenresRepository_whenSuccessfullyGetsMovieGenres_shouldReturnGenres() {
        // given
        let networkService = NetworkServiceMock()
        let expectedGenres = [
            Genre(id: Genre.Identifier(50), name: "Genre1"),
            Genre(id: Genre.Identifier(100), name: "Genre2"),
        ]
        networkService.resultValue = .success(expectedGenres)
        
        let sut = GenresRepository(networkService: networkService)
        
        // when
        let returnedGenres = try? sut.getMovieGenres().get()
        
        // then
        XCTAssertEqual(returnedGenres, expectedGenres)
    }
    
    func test_GenresRepository_whenFailsToGetMovieGenres_shouldHandleFailure() {
        // given
        let networkService = NetworkServiceMock()
        let expectedResult: Result<[Genre], Error> = .failure(GenresRepositorySuccessTestError.failedFetching)
        networkService.resultValue = expectedResult
        
        let sut = GenresRepository(networkService: networkService)
                
        // then
        XCTAssertThrowsError(try sut.getMovieGenres().get(), "A GenresRepositorySuccessTestError should have been thrown but no Error was thrown") { error in
            XCTAssertEqual(error as? GenresRepositorySuccessTestError, GenresRepositorySuccessTestError.failedFetching)
        }
        
    }
}

private class NetworkServiceMock: NetworkServiceProtocol {
    var resultValue: Result<[Genre], Error>?
    
    func request() -> Result<[Genre], Error> {
        return resultValue!
    }
}
