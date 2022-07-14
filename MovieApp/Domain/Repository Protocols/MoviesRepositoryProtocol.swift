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
    func getMovies(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}
