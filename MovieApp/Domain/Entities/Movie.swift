//
//  Movie.swift
//  MovieApp
//
//  Created by Paul on 21/06/2022.
//

import Foundation

struct Movie: Equatable, Identifiable {
    typealias Identifier = String
    
    let adult: Bool
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]
    let homepage: String?
    let id: Identifier
    let imdbId: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}

struct MoviesPage: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}
