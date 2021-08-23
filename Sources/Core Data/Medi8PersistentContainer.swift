//  Copyright © 2021 Poikile Creations. All rights reserved.

import CoreData
import Stylobate

/// An NSPersistentContainer for the Medi8 data model.
open class Medi8PersistentContainer: NSPersistentContainer {

    public static var sharedInMemoryContainer = Medi8PersistentContainer(inMemoryOnly: false)

    /// An ``NSManagedObjectContext`` backed by an in-memory store. Based on an
    /// idea by https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/
    static var sharedInMemoryContext = sharedInMemoryContainer.viewContext

    public init(inMemoryOnly: Bool = false) {
        let model = NSManagedObjectModel.mergedModel(from: [Medi8.bundle])!
        super.init(name: "Medi8", managedObjectModel: model)

        if inMemoryOnly {
            let inMemoryStoreDescription = NSPersistentStoreDescription()
            inMemoryStoreDescription.type = NSInMemoryStoreType
            persistentStoreDescriptions = [inMemoryStoreDescription]
        }

        loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Persistent store \(storeDescription.type) failed: \(error.localizedDescription)")
            } else {
                print("Successfully loaded \(storeDescription.type)")
            }
        }
    }

    public func clearAll() {
        guard !persistentStoreCoordinator.persistentStores.isEmpty else {
            print("No persistent store have been loaded. Nothing to clear.")
            return
        }

        for entityName in ["Song", "SongVersion", "MasterRelease", "ReleaseVersion", "Artist"] {
            let fetchAllRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchAllRequest.predicate = NSPredicate(value: true)

            do {
                try viewContext.fetch(fetchAllRequest).forEach { (result) in
                    viewContext.delete(result as! NSManagedObject)
                }
                print("succeeded")
            } catch {
                print("failed: (error.localizedDescription)")
            }
        }
    }

}
