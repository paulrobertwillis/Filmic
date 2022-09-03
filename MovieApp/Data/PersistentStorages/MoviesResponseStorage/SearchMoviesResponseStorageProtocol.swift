//
//  SearchMoviesResponseStorageProtocol.swift
//  MovieApp
//
//  Created by Paul on 03/09/2022.
//

import CoreData

protocol SearchMoviesResponseStorageProtocol {
    typealias SearchMoviesResponseStorageResultValue = (Result<MoviesResponseDTO, CoreDataStorageError>)
    typealias SearchMoviesResponseStorageCompletionHandler = (SearchMoviesResponseStorageResultValue) -> Void
    
    func getResponse(for requestDTO: SearchMoviesRequestDTO, completion: @escaping SearchMoviesResponseStorageCompletionHandler)
    func save(responseDTO: MoviesResponseDTO, for requestDTO: SearchMoviesRequestDTO)
}
