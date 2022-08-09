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
    private let managedObjectContext: NSManagedObjectContext
    private let coreDataStorage: CoreDataStorageProtocol
    
    // MARK: - Lifecycle
    
    init(managedObjectContext: NSManagedObjectContext = CoreDataStorage.shared.mainContext, coreDataStorage: CoreDataStorageProtocol = CoreDataStorage.shared) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStorage = coreDataStorage
    }
}

// MARK: - GenresResponseStorageProtocol

extension CoreDataGenresResponseStorage: GenresResponseStorageProtocol {
    func getResponse(for requestDTO: GenresRequestDTO, completion: @escaping GenresResponseStorageCompletionHandler) {

        // TODO: Use requestDTO here!
        
        do {
            let request = GenresResponse.createFetchRequest()
            let genresResponse = try self.managedObjectContext.fetch(request).first
            
            if genresResponse == nil {
                throw CoreDataStorageError.emptyStorageError
            } else {
                completion(.success(genresResponse!.toDTO()))
            }
            
        } catch {
            completion(.failure(CoreDataStorageError.readError))
        }
    }
    
    func save(responseDTO: GenresResponseDTO, for requestDTO: GenresRequestDTO) {
        let requestEntity = requestDTO.toEntity(in: self.managedObjectContext)
        requestEntity.genresResponse = responseDTO.toEntity(in: self.managedObjectContext)
        
        self.coreDataStorage.saveContext(backgroundContext: self.managedObjectContext)
    }
}
