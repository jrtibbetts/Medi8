//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import Medi8
import CoreData
import XCTest

class FetchingTestBase: XCTestCase {

    /// An `NSManagedObjectContext` backed by an in-memory store to make it
    /// suitable for unit testing. Based on an idea by
    /// https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/
    static var testingContext: NSManagedObjectContext = {
        let model = NSManagedObjectModel.mergedModel(from: [Medi8.bundle])!
        let container = NSPersistentContainer(name: "Medi8", managedObjectModel: model)
        let inMemoryStoreDescription = NSPersistentStoreDescription()
        inMemoryStoreDescription.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [inMemoryStoreDescription]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Persistent store \(storeDescription.type) failed: \(error.localizedDescription)")
            } else {
                print("Successfully loaded \(storeDescription.type)")
            }
        }

        print("Container context: \(container.viewContext)")

        return container.viewContext
    }()

}
