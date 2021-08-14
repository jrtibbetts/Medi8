//  Copyright © 2021 Poikile Creations. All rights reserved.

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
        let artists = mediaLibrary.artists
        XCTAssertNotNil(artists)
        XCTAssertEqual(artists.count, 1)
    }

    // MARK: - Songs

    func testAllSongs() {
        let songs = mediaLibrary.songs
        XCTAssertNotNil(songs)
        XCTAssertEqual(songs.count, 14)
    }

    // MARK: - Releases

    func testAllReleases() {
        let releases = mediaLibrary.albums
        XCTAssertNotNil(releases)
        XCTAssertEqual(releases.count, 2)

        let firstRelease = releases.first!
        XCTAssertEqual(firstRelease.versions?.count, 1)
    }

}
