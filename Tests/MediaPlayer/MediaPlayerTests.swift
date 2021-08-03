//  Created by Jason R Tibbetts on 8/2/21.

@testable import Medi8
import Foundation
import XCTest

class MediaPlayerTests: FetchingTestBase {

    var mediaLibrary: MediaLibrary!

    override func setUp() {
        super.setUp()
        mediaLibrary = MockMediaLibrary()
    }

    // MARK: - Artists

    func testArtistByNameOk() {
        let artist = mediaLibrary.artist("Siouxsie and The Banshees")
        XCTAssertNotNil(artist)
        XCTAssertEqual(artist?.name, "Siouxsie and The Banshees")
    }

    func testArtistByUnknownNameIsNil() {
        let artist = mediaLibrary.artist("Some artist that doesn't exist")
        XCTAssertNil(artist)
    }

}
