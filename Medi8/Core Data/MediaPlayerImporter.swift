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
        dispatchQueue.sync { [unowned self] in
//            let albums = MPMediaQuery.albums().collections ?? []

            DispatchQueue.main.async { [weak self] in
                self?.finishedImportingAlbums = true
            }
        }
    }

    func importPlaylists() {
        finishedImportingPlaylists = false
        dispatchQueue.sync { [unowned self] in
            let playlists = MPMediaQuery.playlists().collections ?? []

            for playlist in playlists {
                let medi8Playlist = Playlist(context: self.context)
                medi8Playlist.mediaItemPersistentID = Int64(playlist.persistentID)
                medi8Playlist.title = playlist.title

                let medi8Tracklist = TrackListing(context: self.context)
                medi8Playlist.tracks = medi8Tracklist

                for song in playlist.items {
                    if let medi8SongVersion = SongVersion.withMediaID(Int64(song.persistentID), context: context) {
                        medi8Tracklist.addToSongVersions(medi8SongVersion)
                    }
                }
            }

            DispatchQueue.main.async { [weak self] in
                self?.finishedImportingPlaylists = true
            }
        }
    }

    func importArtists() {
        finishedImportingArtists = false

        dispatchQueue.sync { [unowned self] in
            let songs = MPMediaQuery.songs().items ?? []

            let artistNames = songs
                .compactMap { ArtistName($0.artist ?? "", sortName: $0.sortArtist) }

            _ = Set<ArtistName>(artistNames)
                .sorted()
                .compactMap { (artistName) -> Artist? in
                    print("Importing artist \(artistName.name)")
                    return try? fetchOrCreateArtist(named: artistName.name, sortName: artistName.sortName)
                }

            DispatchQueue.main.async { [weak self] in
                self?.finishedImportingArtists = true
            }
        }
    }

    func importSongs() {
        finishedImportingSongs = false

        dispatchQueue.sync { [unowned self] in
            let songs = MPMediaQuery.songs().items ?? []

            for song in songs {
                if let title = song.title,
                   let artistName = song.artist,
                   let artist = Artist.named(artistName, context: context) {
                    _ = try? fetchOrCreateSong(title: title, by: artist)
                }
            }

            DispatchQueue.main.async { [weak self] in
                self?.finishedImportingSongs = true
            }
        }
    }

    public override init(_ context: NSManagedObjectContext = Medi8PersistentContainer.sharedInMemoryContainer.viewContext) {
        self.authStatus = .notDetermined
        super.init(context)

        MPMediaLibrary.requestAuthorization { [weak self] (authStatus) in
            self?.authStatus = authStatus

            if authStatus == .authorized {
                self?.importArtists()
                self?.importSongs()
                self?.importAlbums()
                self?.importPlaylists()
            }
        }
    }

    open func fetchOrCreateSong(mediaItem: MPMediaItem, artist: Artist) throws -> Song? {
        guard let song = try super.fetchOrCreateSong(title: mediaItem.title ?? "(untitled)",
                                                     by: artist) else {
            return nil
        }

        // Create a corresponding SongVersion. These will be merged later.
        _ = try? fetchOrCreateSongVersion(mediaItem: mediaItem, song: song)

        return song
    }

    open func fetchOrCreateSongVersion(mediaItem: MPMediaItem, song: Song) throws -> SongVersion? {
        guard let version = try super.fetchOrCreateSongVersion(title: mediaItem.title ?? "(untitled)",
                                                               sortTitle: mediaItem.sortTitle,
                                                               song: song) else {
            return nil
        }

        version.mediaItemPersistentID = Int64(mediaItem.persistentID)

        if let lyricString = mediaItem.lyrics {
            let lyrics = Lyrics(context: context)
            lyrics.text = lyricString
            version.lyrics = lyrics
        }

        return version
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
