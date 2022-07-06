//
//  MoviesRepositoryProtocol.swift
//  MovieApp
//
//  Created by Paul on 22/06/2022.
//

import Foundation

protocol MoviesRepositoryProtocol {
    typealias ResultValue = (Result<MoviesPage, Error>)
    typealias CompletionHandler = (ResultValue) -> Void
    
    @discardableResult
    func getMovies(completion: @escaping CompletionHandler) -> URLSessionTask?
}
