//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Medi8
import XCTest

class MockMediaImporterTests: FetchingTestBase {

    func testImportMedia() throws {
        let delegate = Delegate()
        let importer = MockMediaImporter(context: testingContext, delegate: delegate)
        try importer.importMedia()
        XCTAssertTrue(delegate.finishedImporting)
        XCTAssertTrue(delegate.startedImporting)
        XCTAssertNil(delegate.importError)
    }

    class Delegate: NSObject, MediaImporterDelegate {

        var finishedImporting: Bool = false
        var importError: Any?
        var startedImporting: Bool = false

        func didStartImporting() {
            startedImporting = true
        }

        func didFinishImporting(with error: Any?) {
            finishedImporting = true
            importError = error
        }
    }

}
