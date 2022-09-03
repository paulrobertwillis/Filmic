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
        return .init(
            id: Movie.Identifier(id),
            title: self.title,
            posterPath: self.posterPath,
            overview: self.overview,
            releaseDate: self.releaseDate
        )
    }
}
