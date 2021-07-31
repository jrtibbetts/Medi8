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
            .filter { $0.songTitle == song.songTitle && $0.artistName == song.artistName }
    }

}

public class MockMediaLibrary: MediaLibrary {

    public override init() {
        super.init()
        refreshSongs()
        refreshAlbums()
        refreshPlaylists()
    }

    override func refreshSongs() {
        let albumTitle = "A Kiss in the Dreamhouse"
        let artistName = "Siouxsie and The Banshees"
        let comment = "1982/11/05 UK \"A Kiss in the Dreamhouse\" LP (Polydor POLD 5064)"

        songs = [("Cascade", 266, comment),
                 ("Green Fingers", 216, comment),
                 ("Obsession", 231, comment),
                 ("She's a Carnival", 220, comment),
                 ("Circle", 323, comment),
                 ("Melt!", 228, comment),
                 ("Painted Bird", 256, comment),
                 ("Cocoon", 269, comment),
                 ("Slowdive", 265, "1982/10/01 UK \"Slowdive\" 7\" single (Polydor POSP 510)"),
                 ("Fireworks (12\" version)", 277, "1982/05/21 UK \"Fireworks\" 12\" single (Polydor POSPX 450)"),
                 ("Slowdive (12\" version)", 349, "1982/10/01 UK \"Slowdive\" 12\" single (Polydor POSPX 510)"),
                 ("Painted Bird (Workhouse demo)", 229, "2009/99/99 UK \"A Kiss in the Dreamhouse\" remastered CD (Polydor 531 489-6)"),
                 ("Cascade (Workhouse demo)", 354, "2009/99/99 UK \"A Kiss in the Dreamhouse\" remastered CD (Polydor 531 489-6)")
        ].enumerated()
        .map { (trackNumber, arg1) in
            let (title, duration, comment) = arg1

            var song = Song(context: Medi8PersistentContainer.sharedInMemoryContext)
            song.albumArtistName = artistName
            song.albumID = 99
            song.albumTitle = albumTitle
            song.albumTrackNumber = trackNumber + 1
            song.artistName = artistName
            song.comments = comment
            song.discNumber = 1
            song.id = UInt64((trackNumber + 1) + 30)
            song.lyrics = nil
            song.playbackDuration = TimeInterval(duration)
            song.songTitle = title
            song.sortArtistName = artistName)
        }

        var fireworks = Song(context: Medi8PersistentContainer.sharedInMemoryContext)
        fireworks.albumArtistName = artistName
        fireworks.albumID = 100
        fireworks.albumTitle = "Fireworks"
        fireworks.albumTrackNumber = 1
        fireworks.artistName = artistName
        fireworks.comments = nil
        fireworks.discNumber = 1
        fireworks.id = 12312
        fireworks.lyrics = nil
        fireworks.playbackDuration = 203
        fireworks.songTitle = "Fireworks"
        fireworks.sortArtistName = artistName
        songs.append(fireworks)

        let siouxsie = Artist(context: Medi8PersistentContainer.sharedInMemoryContext)
        siouxsie.name = "Siouxsie and The Banshees"
        siouxsie.sortName = nil
    }

    override func refreshAlbums() {
        albums = [
            MockAlbum(artistName: "Siouxsie and The Banshees",
                      id: 99,
                      songs: songs.dropLast(),
                      title: "A Kiss in the Dreamhouse"),
            MockAlbum(artistName: "Siouxsie and The Banshees",
                      id: 100,
                      songs: [songs.last!],
                      title: "Fireworks")
        ]
    }

    override func refreshPlaylists() {
        playlists = [MockPlaylist(persistentID: 23, songs: [songs[0], songs[3], songs[9]], title: "Siouxsie Hits")]
    }

}
