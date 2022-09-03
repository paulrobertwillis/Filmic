//
//  SearchMoviesResponseDTO.swift
//  MovieApp
//
//  Created by Paul on 15/06/2022.
//

import Foundation

struct SearchMoviesResponseDTO: Decodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalResults
        case totalPages
    }
    let page: Int
    let movies: [MovieDTO]
    let totalResults: Int
    let totalPages: Int
}

extension SearchMoviesResponseDTO {
    struct MovieDTO: Decodable, Equatable {
        let posterPath: String?
        let adult: Bool
        let overview: String
        let releaseDate: String
        let genreIds: [Int]
        let id: Int
        let originalTitle: String
        let originalLanguage: String
        let title: String
        let backdropPath: String?
        let popularity: Double
        let voteCount: Int
        let video: Bool
        let voteAverage: Double
    }
}

extension SearchMoviesResponseDTO {
    func toDomain() -> MoviesPage {
        return .init(
            page: self.page,
            totalPages: self.totalPages,
            movies: self.movies.map { $0.toDomain() }
        )
    }
}

extension SearchMoviesResponseDTO.MovieDTO {
    func toDomain() -> Movie {
        return .init(
            id: Movie.Identifier(id),
            title: self.title,
            posterPath: self.posterPath,
            overview: self.overview,
            releaseDate: self.releaseDate
        )
    }
}
