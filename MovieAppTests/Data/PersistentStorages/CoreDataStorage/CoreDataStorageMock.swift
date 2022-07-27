import CoreData
@testable import MovieApp

class CoreDataStorageMock: CoreDataStorage {
    override init() {
        super.init()
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: CoreDataStorage.modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        self.persistentContainer = container
    }
}

//class CoreDataStorageMock: CoreDataStorageProtocol {
//
//    var storeCoordinator: NSPersistentStoreCoordinator!
//    var managedObjectContext: NSManagedObjectContext!
//    var managedObjectModel: NSManagedObjectModel!
//    var store: NSPersistentStore!
//
//    init() {
//        self.managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
//        self.storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//
//        do {
//            self.store = try self.storeCoordinator.addPersistentStore(
//                ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
//        } catch {
//            XCTFail("Failed to create a persistent store, \(error)")
//        }
//        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator
//    }
//
//    // MARK: - saveContext
//
//    func saveContext(backgroundContext: NSManagedObjectContext?) {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // TODO: - Log to Crashlytics
//                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
//            }
//        }
//    }
//
//    // MARK: - performBackgroundTask
//
//    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
//        persistentContainer.performBackgroundTask(block)
//    }
//}
