//
//  MovieResponseDTO.swift
//  MovieApp
//
//  Created by Paul on 03/09/2022.
//

import Foundation

public struct MovieResponseDTO: Decodable, Equatable {
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let genres: [GenreResponseDTO]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}

extension MovieResponseDTO {
    func toDomain() -> Movie {
        return Movie.init(
            adult: self.adult,
            backdropPath: self.backdropPath,
            budget: self.budget,
            genres: self.genres.map { $0.toDomain() },
            homepage: self.homepage,
            id: Movie.Identifier(id),
            imdbId: self.imdbId,
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            overview: self.overview,
            popularity: self.popularity,
            posterPath: self.posterPath,
            releaseDate: self.releaseDate,
            revenue: self.revenue,
            runtime: self.runtime,
            status: self.status,
            tagline: self.tagline,
            title: self.title,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount
        )
    }
}
