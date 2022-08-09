//
//  GenresResponseStorage.swift
//  MovieApp
//
//  Created by Paul on 12/07/2022.
//

import CoreData

protocol GenresResponseStorageProtocol {
    typealias GenresResponseStorageResultValue = (Result<GenresResponseDTO, CoreDataStorageError>)
    typealias GenresResponseStorageCompletionHandler = (GenresResponseStorageResultValue) -> Void
    
    func getResponse(for requestDTO: GenresRequestDTO, completion: @escaping GenresResponseStorageCompletionHandler)
    func save(responseDTO: GenresResponseDTO, for requestDTO: GenresRequestDTO)
}
