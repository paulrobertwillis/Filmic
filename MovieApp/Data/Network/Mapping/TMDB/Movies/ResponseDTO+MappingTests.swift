//
//  MoviesResponseDTO+MappingTests.swift
//  MovieAppTests
//
//  Created by Paul on 03/09/2022.
//

import XCTest
@testable import MovieApp

class ResponseDTOTests: XCTestCase {
        
    func test_Decoding_GenresResponseDTO() {
        XCTAssertNotNil(GenresResponseDTO.from(file: "GenresResponseDTOMock"))
    }
    
    func test_Decoding_SearchMoviesResponseDTO() {
        XCTAssertNotNil(SearchMoviesResponseDTO.from(file: "SearchMoviesResponseDTOMock"))
    }
}

