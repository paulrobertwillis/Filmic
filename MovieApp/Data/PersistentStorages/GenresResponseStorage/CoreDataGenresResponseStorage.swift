//
//  CoreDataGenresResponseStorage.swift
//  MovieApp
//
//  Created by Paul on 14/07/2022.
//

import Foundation
import CoreData

class CoreDataGenresResponseStorage {
    
    // MARK: - Private Properties
    
    private var cache: [URLRequest : GenresResponseDTO] = [:]
    
    private let coreDataStorage: CoreDataStorageProtocol
    
    // MARK: - Lifecycle
    
    init(coreDataStorage: CoreDataStorageProtocol = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
}

// MARK: - GenresResponseStorageProtocol

extension CoreDataGenresResponseStorage: GenresResponseStorageProtocol {
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
