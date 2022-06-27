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
        
    func test_GenresRepository_whenGetMovieGenres_shouldReturnGenres() {
        // given
        let networkService = NetworkServiceMock()
        let expectedGenres = [
            Genre(id: Genre.Identifier(50), name: "Genre1"),
            Genre(id: Genre.Identifier(100), name: "Genre2"),
        ]
        networkService.returnValue = expectedGenres
        
        let sut = GenresRepository(networkService: networkService)
        
        // when
        let returnedGenres = sut.getMovieGenres()
        
        // then
        XCTAssertEqual(returnedGenres, expectedGenres)
    }
    
    
}

private class NetworkServiceMock: NetworkServiceProtocol {
    var returnValue: [Genre] = []
    
    func request() -> [Genre] {
        returnValue
    }
}


