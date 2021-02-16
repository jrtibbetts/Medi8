//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import Medi8
import CoreData
//import Stylobate
import XCTest

class FetchingTestBase: XCTestCase {

    /// An `NSManagedObjectContext` backed by an in-memory store to make it
    /// suitable for unit testing. Based on an idea by
    /// https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/
    static var testingContext: NSManagedObjectContext = {
        return Medi8.modelContainer.viewContext
//        if let modelUrl = Medi8.resourceBundle.url(forResource: "Medi8", withExtension: "momd"),
//           let model = NSManagedObjectModel(contentsOf: modelUrl) {
//            let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//            let stoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
//
//            do {
//                try stoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
//                                                    configurationName: nil,
//                                                    at: nil,
//                                                    options: nil)
//                moc.persistentStoreCoordinator = stoordinator
//            } catch {
//                preconditionFailure("The FetchingTestBase couldn't set up a persistent in-memory store")
//            }
//
//            return moc
//        }
//
//        fatalError("Failed to initialize an in-memory context")
    }()

}
