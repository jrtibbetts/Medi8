//  Copyright © 2021 Poikile Creations. All rights reserved.

import Stylobate

import CoreData

/// An NSPersistentContainer for the Medi8 data model.
open class Medi8PersistentContainer: NSPersistentContainer {

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

}
