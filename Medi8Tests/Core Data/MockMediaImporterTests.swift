//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Medi8
import CoreData
import XCTest

class MockMediaImporterTests: FetchingTestBase {

    func testImportMedia() throws {
        let delegate = Delegate()
        let importer = MockMediaImporter(context: FetchingTestBase.testingContext, delegate: delegate)
        try importer.importMedia()
        XCTAssertTrue(delegate.finishedImporting)
        XCTAssertTrue(delegate.startedImporting)
        XCTAssertNil(delegate.importError)
    }

    func testFullModel() throws {
        let importer = MockMediaImporter(context: FetchingTestBase.testingContext)
        try importer.importMedia()

        let artistRequest: NSFetchRequest<NSFetchRequestResult> = Artist.fetchRequest()
        let theBeatles = try FetchingTestBase.testingContext.fetch(artistRequest)[0] as! Artist
        let beatlesSongs = theBeatles.songs
        XCTAssertNotNil(beatlesSongs)
        XCTAssertEqual(beatlesSongs!.count, 205)

        let freeAsABird = Song(context: FetchingTestBase.testingContext)
        freeAsABird.title = "Free as a Bird"
        theBeatles.addToSongs(freeAsABird)
        XCTAssertEqual(beatlesSongs!.count, 206)
        freeAsABird.removeFromArtists(theBeatles)
        XCTAssertEqual(beatlesSongs!.count, 205)
    }

    class Delegate: MediaImporter.Delegate {

        var finishedImporting: Bool = false

        var importError: Any?

        var startedImporting: Bool = false

        override func didStartImporting() {
            startedImporting = true
        }

        override func didFinishImporting(with error: Any?) {
            finishedImporting = true
            importError = error
        }
        
    }

}
