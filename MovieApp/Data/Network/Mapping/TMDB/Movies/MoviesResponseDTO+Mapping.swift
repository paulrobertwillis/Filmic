//
//  MoviesResponseDTO+Mapping.swift
//  MovieApp
//
//  Created by Paul on 03/09/2022.
//

import Foundation

public struct MoviesResponseDTO: PaginatedResponseDTO {
    public typealias T = MovieDTO
    
    public let page: Int
    public let results: [MovieDTO]
    public let totalResults: Int
    public let totalPages: Int
}

extension MoviesResponseDTO {
    public struct MovieDTO: Decodable, Equatable {
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

extension MoviesResponseDTO {
    func toDomain() -> MoviesPage {
        return .init(
            page: self.page,
            totalPages: self.totalPages,
            movies: self.results.map { $0.toDomain() }
        )
    }
}

extension MoviesResponseDTO.MovieDTO {
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
