//
//  MoviesRepositoryProtocol.swift
//  MovieApp
//
//  Created by Paul on 22/06/2022.
//

import Foundation

protocol MoviesRepositoryProtocol {
    func getMovies() -> [Movie]
}
