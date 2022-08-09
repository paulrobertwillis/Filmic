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
    
    private var cache: [GenresRequestDTO : GenresResponseDTO] = [:]
    
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
        
        if let returnValue = self.cache[requestDTO] {
            completion(.success(returnValue))
        } else {
            completion(.failure(CoreDataStorageError.readError))
        }
    }
        
    func save(responseDTO: GenresResponseDTO, for requestDTO: GenresRequestDTO) {
        self.cache[requestDTO] = responseDTO
        
        let requestEntity = requestDTO.toEntity(in: self.managedObjectContext)
        requestEntity.genresResponse = responseDTO.toEntity(in: self.managedObjectContext)
        
        self.coreDataStorage.saveContext(backgroundContext: self.managedObjectContext)
    }
    
//    public func add(_ location: String, numberTested: Int32, numberPositive: Int32, numberNegative: Int32) -> PandemicReport {
//      let report = PandemicReport(context: managedObjectContext)
//      report.id = UUID()
//      report.dateReported = Date()
//      report.numberTested = numberTested
//      report.numberNegative = numberNegative
//      report.numberPositive = numberPositive
//      report.location = location
//
//      coreDataStack.saveContext(managedObjectContext)
//      return report
//    }
}
