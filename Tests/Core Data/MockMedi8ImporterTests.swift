//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Medi8
import CoreData
import XCTest

class MockMedi8ImporterTests: FetchingTestBase {

    func testImportMedia() throws {
        let delegate = Delegate()
        let importer = MockMedi8Importer(context: Self.testingContext, delegate: delegate)
        try importer.importMedia()
        XCTAssertTrue(delegate.finishedImporting)
        XCTAssertTrue(delegate.startedImporting)
        XCTAssertNil(delegate.importError)
    }

    func testFullModel() throws {
        let importer = MockMedi8Importer(context: Self.testingContext)
        try importer.importMedia()

        let theBeatles = Artist.named("The Beatles", context: Self.testingContext)!
        let beatlesSongs = theBeatles.songs
        XCTAssertNotNil(beatlesSongs)
        XCTAssertEqual(beatlesSongs!.count, 205)

        let freeAsABird = Song(context: Self.testingContext)
        freeAsABird.title = "Free as a Bird"
        theBeatles.addToSongs(freeAsABird)
        XCTAssertEqual(beatlesSongs!.count, 206)
        freeAsABird.removeFromArtists(theBeatles)
        XCTAssertEqual(beatlesSongs!.count, 205)
    }

    func testArtist() throws {
        let importer = MockMedi8Importer(context: Self.testingContext)
        try importer.importMedia()

        let artist = Artist.named("The Beatles", context: Self.testingContext)
        XCTAssertNotNil(artist)
    }

    class Delegate: MediaImporterDelegate {

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

// swiftlint:enable force_cast
