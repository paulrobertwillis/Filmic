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
        case totalPages = "total_pages"
        case movies = "results"
    }
    let page: Int
    let totalPages: Int
    let movies: [MovieDTO]
}

extension SearchMoviesResponseDTO {
    struct MovieDTO: Decodable, Equatable {
        private enum CodingKeys: String, CodingKey {
            case id
            case title
            case posterPath = "poster_path"
            case overview
            case releaseDate = "release_date"
        }
        let id: Int
        let title: String
        let posterPath: String?
        let overview: String
        let releaseDate: String
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
