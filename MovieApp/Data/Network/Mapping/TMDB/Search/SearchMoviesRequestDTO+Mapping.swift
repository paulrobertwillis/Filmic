//
//  SearchMoviesRequestDTO+Mapping.swift
//  MovieApp
//
//  Created by Paul on 03/09/2022.
//

import Foundation

struct SearchMoviesRequestDTO: Encodable {
    let query: String
    let page: Int
}
