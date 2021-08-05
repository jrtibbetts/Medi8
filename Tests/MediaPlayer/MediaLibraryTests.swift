//  Created by Jason R Tibbetts on 8/2/21.

@testable import Medi8
import Foundation
import XCTest

class MediaLibraryTests: FetchingTestBase {

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

    func testAllArtists() {
        let artists = mediaLibrary.allArtists()
        XCTAssertNotNil(artists)
        XCTAssertEqual(artists?.count, 1)
    }

    // MARK: - Songs

    func testAllSongs() {
        let songs = mediaLibrary.allSongs()
        XCTAssertNotNil(songs)
        XCTAssertEqual(songs?.count, 13)
    }

    // MARK: - Releases

    func testAllReleases() {
        let releases = mediaLibrary.allMasterReleases()
        XCTAssertNotNil(releases)
        XCTAssertEqual(releases?.count, 2)
    }

}
