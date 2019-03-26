//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import Medi8
import CoreData
import XCTest

class FetchingTestBase: XCTestCase {

    /// An `NSManagedObjectContext` backed by an in-memory store to make it
    /// suitable for unit testing. Based on an idea by
    /// https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/
    static var testingContext: NSManagedObjectContext = {
        let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: FetchedResultsModel.self)])!
        let stoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! stoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = stoordinator

        return moc
    }()

    override func tearDown() {
        FetchingTestBase.testingContext.reset()
        super.tearDown()
    }

}
