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
    
    private let coreDataStorage: CoreDataStorage
    
    // MARK: - Lifecycle
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Helpers
    
//    private func fetchRequest(for requestDTO: GenresRequestDTO) -> NSFetchRequest<NSManagedObject> {
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GenresResponseEntity")
//    }
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
