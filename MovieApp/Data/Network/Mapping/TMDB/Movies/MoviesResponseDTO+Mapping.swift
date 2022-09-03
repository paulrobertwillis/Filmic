//
//  MoviesResponseDTO+Mapping.swift
//  MovieApp
//
//  Created by Paul on 03/09/2022.
//

import Foundation

public struct PaginatedResponseDTO<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let totalResults: Int
    let totalPages: Int
}

public struct MoviesResponseDTO: Decodable, Equatable {
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

extension MoviesResponseDTO {
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
