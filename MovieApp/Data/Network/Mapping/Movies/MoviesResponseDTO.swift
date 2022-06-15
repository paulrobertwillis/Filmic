//
//  MoviesResponseDTO.swift
//  MovieApp
//
//  Created by Paul on 15/06/2022.
//

import Foundation

struct MoviesResponseDTO: Decodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
    let page: Int
    let totalPages: Int
    let movies: [MovieDTO]
}

extension MoviesResponseDTO {
    struct MovieDTO: Decodable, Equatable {
        private enum CodingKeys: String, CodingKey {
            case posterPath = "poster_path"
            case overview
            case releaseDate = "release_date"
            case genreIds = "genre_ids"
            case id
            case title
        }
        let posterPath: String?
        let overview: String
        let releaseDate: String
        let genreIds: [Int]
        let id: Int
        let title: String
    }
}
