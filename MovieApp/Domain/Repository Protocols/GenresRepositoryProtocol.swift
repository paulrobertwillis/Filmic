//
//  GenresRepositoryProtocol.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

protocol GenresRepositoryProtocol {
    typealias ResultValue = (Result<[Genre], Error>)
    typealias GenresRepositoryCompletionHandler = (ResultValue) -> Void
    
    @discardableResult
    func getMovieGenres(completion: @escaping GenresRepositoryCompletionHandler) -> URLSessionTask?
}
