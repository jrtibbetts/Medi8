//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import Medi8
import CoreData
import XCTest

class FetchingTestBase: XCTestCase {

    static var persistentContainer = Medi8PersistentContainer(inMemoryOnly: true)

    /// An `NSManagedObjectContext` backed by an in-memory store to make it
    /// suitable for unit testing. Based on an idea by
    /// https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/
    static var testingContext = persistentContainer.viewContext

}
