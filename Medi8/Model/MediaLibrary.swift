//  Created by Jason R Tibbetts on 3/19/21.

import MediaPlayer
import SwiftUI

public class MediaLibrary: ObservableObject {

    @Published var albums = [Album]()

    @Published var artists = [Artist]()

    @Published var playlists = [Playlist]()

    @Published var songs = [Song]()

    @Published var finishedImporting: Bool = true

    #if !os(macOS)
    @Published var authStatus: MPMediaLibraryAuthorizationStatus = .authorized
    #endif

    func refreshAlbums() {
    }

    func refreshPlaylists() {
    }

    func refreshSongs() {
    }

    init() {
    }

    func allVersionsOf(_ song: Song) -> [Song]? {
        return songs
            .filter { $0.title == song.title && $0.artistName == song.artistName }
    }

}

public class MockMediaLibrary: MediaLibrary {

    private let context = Medi8PersistentContainer.sharedInMemoryContext

    public override init() {
        super.init()
        refreshSongs()
        refreshAlbums()
        refreshPlaylists()
    }

    override func refreshSongs() {
        let siouxsie = Artist(context: context)
        siouxsie.name = "Siouxsie and The Banshees"
        siouxsie.sortName = nil

        let release = MasterRelease(context: context)
        release.title = "A Kiss in the Dreamhouse"
        release.artists = [siouxsie]

        let releaseVersion = ReleaseVersion(context: context)
        releaseVersion.parentRelease = release
        let comment = "1982/11/05 UK \"A Kiss in the Dreamhouse\" LP (Polydor POLD 5064)"
        let tracklist = TrackListing(context: context)

        songs = [("Cascade", 266.0, comment),
                 ("Green Fingers", 216.0, comment),
                 ("Obsession", 231.0, comment),
                 ("She's a Carnival", 220, comment),
                 ("Circle", 323.0, comment),
                 ("Melt!", 228.0, comment),
                 ("Painted Bird", 256.0, comment),
                 ("Cocoon", 269.0, comment),
                 ("Slowdive", 265.0, "1982/10/01 UK \"Slowdive\" 7\" single (Polydor POSP 510)"),
                 ("Fireworks (12\" version)", 277.0, "1982/05/21 UK \"Fireworks\" 12\" single (Polydor POSPX 450)"),
                 ("Slowdive (12\" version)", 349.0, "1982/10/01 UK \"Slowdive\" 12\" single (Polydor POSPX 510)"),
                 ("Painted Bird (Workhouse demo)", 229.0, "2009/99/99 UK \"A Kiss in the Dreamhouse\" remastered CD (Polydor 531 489-6)"),
                 ("Cascade (Workhouse demo)", 354.0, "2009/99/99 UK \"A Kiss in the Dreamhouse\" remastered CD (Polydor 531 489-6)")
        ].enumerated()
        .map { (trackNumber, arg1) in
            let (title, duration, comment) = arg1

            let song = Song(context: context)
            song.title = title
            song.artists = [siouxsie]
            song.lyrics = nil

            let songVersion = SongVersion(context: context)
            songVersion.comment = comment
            songVersion.duration = duration
            tracklist.addToSongVersions(songVersion)
        }

        let fireworksRelease = MasterRelease(context: context)
        fireworksRelease.title = "Fireworks"
        fireworksRelease.artists = [siouxsie]

        let fireworksReleaseVersion = ReleaseVersion(context: context)
        fireworksReleaseVersion.parentRelease = fireworksRelease

        let fireworksSong = Song(context: context)
        fireworksSong.title = "Fireworks"
        fireworksSong.lyrics = nil

        let fireworksSongVersion = SongVersion(context: context)
        fireworksSongVersion.comment = nil
        fireworksSongVersion.duration = 203.0
    }

    override func refreshAlbums() {
    }

    override func refreshPlaylists() {
        let playlist = Playlist(context: context)
        playlist.title = "Siouxsie Hits"
        let trackListing = TrackListing(context: context)
//        trackListing.songVersions = [try? context.fetch(SongVersion.fetchRequestForAll())].flatMap
    }

}
