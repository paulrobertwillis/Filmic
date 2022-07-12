//
//  MovieGenresResponseStorage.swift
//  MovieApp
//
//  Created by Paul on 12/07/2022.
//

import CoreData

protocol GenresResponseStorageProtocol {
    typealias ResultValue = (Result<GenresResponseDTO, Error>)
    typealias GenresResponseStorageCompletionHandler = (ResultValue) -> Void
    func getResponse(for request: URLRequest, completion: @escaping GenresResponseStorageCompletionHandler)
    func save(response: GenresResponseDTO, for requestDTO: URLRequest)
}

class GenresResponseStorage {
    public var cache: [URLRequest : GenresResponseDTO] = [:]
}

// MARK: - GenresResponseStorageProtocol

extension GenresResponseStorage: GenresResponseStorageProtocol {
    func getResponse(for request: URLRequest, completion: @escaping GenresResponseStorageCompletionHandler) {
        if let returnValue = self.cache[request] {
            completion(.success(returnValue))
        } else {
            completion(.failure(GenresResponseStorageError.readError))
        }
    }
        
    func save(response: GenresResponseDTO, for requestDTO: URLRequest) {
        self.cache[requestDTO] = response
    }
}

private enum GenresResponseStorageError: Error {
    case readError
}
