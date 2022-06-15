//
//  MoviesResponseDTOTests.swift
//  MovieAppTests
//
//  Created by Paul on 15/06/2022.
//

import XCTest
@testable import MovieApp

class MoviesResponseDTOTests: XCTestCase {

    func testMoviesResponseDTO_whenDecoded_shouldInitialise() {
        // given
        let expected = MoviesResponseDTO(page: 1, totalPages: 5, movies: self.movies)
        
        // when
        let actual = try? JSONDecoder().decode(MoviesResponseDTO.self, from: self.moviesResponseDTO.data(using: .utf8)!)
        
        // then
        XCTAssertEqual(actual, expected)
    }
    
    let movies = [
        MoviesResponseDTO.MovieDTO(
            posterPath: "/posterpath1.jpg",
            overview: "movie1 overview",
            releaseDate: "2001-01-01",
            genreIds: [1, 2, 3],
            id: 50,
            title: "movie1"
        ),
        MoviesResponseDTO.MovieDTO(
            posterPath: "/posterpath2.jpg",
            overview: "movie2 overview",
            releaseDate: "2002-01-01",
            genreIds: [4, 5, 6],
            id: 200,
            title: "movie2"
        )
    ]
    
    let moviesResponseDTO = """
        {
            "page": 1,
            "results": [
                {
                    "adult": false,
                    "backdrop_path": "/backdroppath1.jpg",
                    "genre_ids": [
                        1,
                        2,
                        3
                    ],
                    "id": 50,
                    "original_language": "en",
                    "original_title": "originaltitle1",
                    "overview": "movie1 overview",
                    "popularity": 1.00,
                    "poster_path": "/posterpath1.jpg",
                    "release_date": "2001-01-01",
                    "title": "movie1",
                    "video": false,
                    "vote_average": 5.0,
                    "vote_count": 101
                },
                {
                    "adult": false,
                    "backdrop_path": "/backdroppath2.jpg",
                    "genre_ids": [
                        4,
                        5,
                        6
                    ],
                    "id": 200,
                    "original_language": "fr",
                    "original_title": "originaltitle2",
                    "overview": "movie2 overview",
                    "popularity": 2.05,
                    "poster_path": "/posterpath2.jpg",
                    "release_date": "2002-01-01",
                    "title": "movie2",
                    "video": false,
                    "vote_average": 6.4,
                    "vote_count": 202
                },
            ],
            "total_pages": 5,
            "total_results": 50
        }
        """
}
