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
    
    func getResponse(for request: URLRequest, completion: @escaping GenresResponseStorageCompletionHandler)
    func save(response: GenresResponseDTO, for request: URLRequest)
}

class GenresResponseStorage {
    private var cache: [URLRequest : GenresResponseDTO] = [:]
}

// MARK: - GenresResponseStorageProtocol

extension GenresResponseStorage: GenresResponseStorageProtocol {
    func getResponse(for request: URLRequest, completion: @escaping GenresResponseStorageCompletionHandler) {
        if let returnValue = self.cache[request] {
            completion(.success(returnValue))
        } else {
            completion(.failure(CoreDataStorageError.readError))
        }
    }
        
    func save(response: GenresResponseDTO, for request: URLRequest) {
        self.cache[request] = response
    }
}
