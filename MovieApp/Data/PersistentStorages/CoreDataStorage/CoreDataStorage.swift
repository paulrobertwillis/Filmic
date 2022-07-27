//
//  CoreDataStorage.swift
//  MovieApp
//
//  Created by Paul on 12/07/2022.
//

import CoreData

enum CoreDataStorageError: Error {
    case readError
    case saveError
}

protocol CoreDataStorageProtocol {
    func saveContext(backgroundContext: NSManagedObjectContext?)
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}

class CoreDataStorage {
    public static let modelName = "DataModel"
    
    static let shared = CoreDataStorage()
    
    // MARK: - Core Data stack
    // taken from Apple Documentation: https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStorage.modelName)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
}

// MARK: - CoreDataStorageProtocol

extension CoreDataStorage: CoreDataStorageProtocol {
    // MARK: - Core Data Saving support
    // taken from Apple Documentation: https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? self.persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        
    }
}

