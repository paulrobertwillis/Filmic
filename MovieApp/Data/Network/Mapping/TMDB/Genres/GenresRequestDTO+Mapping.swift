//
//  GenresRequestDTO+Mapping.swift
//  MovieApp
//
//  Created by Paul on 14/07/2022.
//

import Foundation

enum GenreType: String, Encodable {
    case movie
    case tv
}

struct GenresRequestDTO: Encodable, Hashable {
    let type: GenreType
}
