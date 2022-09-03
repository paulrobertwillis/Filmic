//
//  MoviesResponseDTO+MappingTests.swift
//  MovieAppTests
//
//  Created by Paul on 03/09/2022.
//

import XCTest
@testable import MovieApp

class ResponseDTOTests: XCTestCase {
    
    // MARK: - Decoding
        
    func test_decoding_genresResponseDTO() {
        XCTAssertNotNil(GenresResponseDTO.from(file: "GenresResponseDTOMock"))
    }
    
    func test_decoding_movieResponseDTO() {
        XCTAssertNotNil(MovieResponseDTO.from(file: "MovieResponseDTOMock"))
    }
    
    func test_decoding_moviesResponseDTO() {
        XCTAssertNotNil(MoviesResponseDTO.from(file: "MoviesResponseDTOMock"))
    }
    
    // MARK: - toDomain
    
    func test_toDomain_genresResponseDTO() {
        XCTAssertNotNil(GenresResponseDTO.from(file: "GenresResponseDTOMock")?.genres.map { $0.toDomain() })
    }
    
    func test_toDomain_movieResponseDTO() {
        XCTAssertNotNil(MovieResponseDTO.from(file: "MovieResponseDTOMock")?.toDomain())
    }
    
    func test_toDomain_moviesResponseDTO() {
        XCTAssertNotNil(MoviesResponseDTO.from(file: "MoviesResponseDTOMock")?.results.map { $0.toDomain() })
    }
}

