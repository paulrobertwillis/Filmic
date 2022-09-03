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
        let adult: Bool
        let backdropPath: String?
        let genreIds: [Int]
        let id: Int
        let originalLanguage: String
        let originalTitle: String
        let overview: String
        let popularity: Double
        let posterPath: String?
        let releaseDate: String
        let title: String
        let video: Bool
        let voteAverage: Double
        let voteCount: Int
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
        return Movie.init(
            adult: self.adult,
            backdropPath: self.backdropPath,
            budget: nil,
            genres: [],
            homepage: nil,
            id: Movie.Identifier(id),
            imdbId: nil,
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            overview: self.overview,
            popularity: self.popularity,
            posterPath: self.posterPath,
            releaseDate: self.releaseDate,
            revenue: nil,
            runtime: nil,
            status: nil,
            tagline: nil,
            title: self.title,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount
        )
    }
}
