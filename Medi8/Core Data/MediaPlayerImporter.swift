//  Created by Jason R Tibbetts on 4/3/21.

import CoreData
import MediaPlayer
import SwiftUI

open class MediaPlayerImporter: Medi8Importer {

    @Published var authStatus: MPMediaLibraryAuthorizationStatus

    @Published var finishedImporting: Bool = false

    private var finishedImportingAlbums = false {
        didSet {
            finishedImporting = finishedImportingAlbums && finishedImportingArtists && finishedImportingPlaylists && finishedImportingSongs
        }
    }

    private var finishedImportingArtists = false {
        didSet {
            finishedImporting = finishedImportingAlbums && finishedImportingArtists && finishedImportingPlaylists && finishedImportingSongs
        }
    }

    private var finishedImportingPlaylists = false {
        didSet {
            finishedImporting = finishedImportingAlbums && finishedImportingArtists && finishedImportingPlaylists && finishedImportingSongs
        }
    }

    private var finishedImportingSongs = false {
        didSet {
            finishedImporting = finishedImportingAlbums && finishedImportingArtists && finishedImportingPlaylists && finishedImportingSongs
        }
    }

    private var dispatchQueue = DispatchQueue(label: "MediaLibrary")

    open func importAlbums() {
        finishedImportingAlbums = false
        dispatchQueue.async {
            let albums = MPMediaQuery.albums().collections ?? []

            DispatchQueue.main.async { [weak self] in
                self?.finishedImportingAlbums = true
            }
        }
    }

    func importPlaylists() {
        finishedImportingPlaylists = false
        dispatchQueue.async { [weak self] in
            let playlists = MPMediaQuery.playlists().collections ?? []

            DispatchQueue.main.async { [weak self] in
                self?.finishedImportingPlaylists = true
            }
        }
    }

    func importSongs() {
        finishedImportingSongs = false
        finishedImportingArtists = false

        dispatchQueue.async { [unowned self] in
            let songs = MPMediaQuery.songs().items ?? []

            let artistNames = songs
                .compactMap { ArtistName($0.artist ?? "", sortName: $0.sortArtist) }

            _ = Set<ArtistName>(artistNames)
                .sorted()
                .compactMap { (artistName) -> Artist? in
                    print("Importing artist \(artistName.name)")
                    return try? fetchOrCreateArtist(named: artistName.name, sortName: artistName.sortName)
                }

            for song in songs {
                if let title = song.title,
                   let artistName = song.artist,
                   let artist = Artist.named(artistName, context: context) {
                    _ = try? fetchOrCreateSong(named: title, by: artist)
                }
            }

            DispatchQueue.main.async { [weak self] in
                self?.finishedImportingSongs = true
                self?.finishedImportingArtists = true
            }
        }
    }

    public override init(_ context: NSManagedObjectContext) {
        self.authStatus = .notDetermined
        super.init(context)

        MPMediaLibrary.requestAuthorization { [weak self] (authStatus) in
            self?.authStatus = authStatus

            if authStatus == .authorized {
                self?.importAlbums()
                self?.importPlaylists()
                self?.importSongs()
            }
        }
    }

    struct ArtistName: Hashable, Comparable {

        var name: String
        var sortName: String

        init(_ name: String, sortName: String?) {
            self.name = name
            self.sortName = sortName ?? name
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(sortName)
        }

        static func < (lhs: ArtistName, rhs: ArtistName) -> Bool {
            return lhs.sortName < rhs.sortName
        }
    }

}

private extension Song {

    convenience init(_ mediaLibrarySong: MPMediaItem, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = mediaLibrarySong.title

//        if let lyricString = mediaLibrarySong.lyrics {
//            let lyrics = Lyrics(context: context)
//            lyrics.text = lyricString
//        }
    }
}
