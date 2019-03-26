//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Medi8
import CoreData
import XCTest

class FetchedResultsModelTests: FetchingTestBase {

    override class func setUp() {
        let mediaImporter = MockMediaImporter(context: FetchingTestBase.testingContext)
        try! mediaImporter.importMedia()
    }

}
