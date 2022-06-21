//
//  Movie.swift
//  MovieApp
//
//  Created by Paul on 21/06/2022.
//

import Foundation

struct Movie: Equatable, Identifiable {
    typealias Identifier = String

    let id: Identifier
    let title: String?
    let posterPath: String?
    let overview: String?
    let releaseDate: String?
}

struct MoviesPage: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}
