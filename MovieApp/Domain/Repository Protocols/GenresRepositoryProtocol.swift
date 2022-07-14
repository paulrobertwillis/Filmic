//
//  GenresRepositoryProtocol.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

protocol GenresRepositoryProtocol {
    typealias ResultValue = (Result<[Genre], Error>)
    typealias CompletionHandler = (ResultValue) -> Void
    
    @discardableResult
    func getMovieGenres(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}
