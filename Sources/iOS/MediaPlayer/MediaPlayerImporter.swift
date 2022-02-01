//  Copyright © 2021 Poikile Creations. All rights reserved.

#if !os(macOS)

import Combine
import CoreData
import MediaPlayer
import SwiftUI

open class MediaPlayerImporter: Medi8Importer {

    @Published var authStatus: MPMediaLibraryAuthorizationStatus

    @Published var finishedImporting: Bool = false

    private(set) var mediaLibrary: MediaLibrary

    private var dispatchQueue = DispatchQueue(label: "MediaLibrary")

    open func importAll() async throws {
        if authStatus == .authorized {
            try await importArtists()
            try await importSongs()
            try await importAlbums()
            try await importPlaylists()
        }
    }

    open func importAlbums() async throws {
        //            let albums = MPMediaQuery.albums().collections ?? []

        try context.parent?.save()
    }

    func importPlaylists() async throws {
        print("Importing playlists")
        let playlists = MPMediaQuery.playlists().collections ?? []

        for playlist in playlists {
            let medi8Playlist: Playlist = Playlist(context: self.context)
            medi8Playlist.mediaItemPersistentID = "\(playlist.persistentID)"
            medi8Playlist.title = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String

            let medi8Tracklist = TrackListing(context: self.context)
            medi8Playlist.tracks = medi8Tracklist

            for songVersion in playlist.items {
                if let medi8SongVersion = SongVersion.withMediaID(Int64(songVersion.persistentID), context: context) {
                    medi8Tracklist.addToSongVersions(medi8SongVersion)
                }
            }

            try context.save()
        }

        try context.parent?.save()
    }

    func importArtists() async throws {
        print("Importing artists")

        let songVersions = MPMediaQuery.songs().items ?? []

        let artistNames = songVersions
            .compactMap { ArtistName($0.artist ?? "", sortName: $0.sortArtist) }

        _ = Set<ArtistName>(artistNames)
            .sorted()
            .compactMap { (artistName) -> Artist? in
                print("Importing artist \(artistName.name)")

                do {
                    let artist = try fetchOrCreateArtist(named: artistName.name, sortName: artistName.sortName)
                    try context.save()

                    return artist
                } catch {
                    print("Failed to create artist named '\(artistName.name)': \(error.localizedDescription)")
                    return nil
                }
            }

        try context.parent?.save()
    }

    func importSongs() async throws {
        let mediaItems = MPMediaQuery.songs().items ?? []

        for mediaItem in mediaItems {
            if let title = mediaItem.title,
               let artistName = mediaItem.artist {

                do {
                    if let artist = mediaLibrary.artist(artistName) {
                        _ = try fetchOrCreateSong(title: title, by: artist)
                    }
                } catch {
                    print("Failed to create song named '\(title)' by \(artistName): \(error.localizedDescription)")
                }
            }

            try context.save()
        }

        try context.parent?.save()
    }

    // MARK: - Initialization

    public init(_ context: NSManagedObjectContext = Medi8PersistentContainer.sharedInMemoryContainer.viewContext,
                mediaLibrary: MediaLibrary) {
        self.authStatus = .notDetermined
        self.mediaLibrary = mediaLibrary
        super.init(context)

        MPMediaLibrary.requestAuthorization { [weak self] (authStatus) in
            self?.authStatus = authStatus
        }
    }

    open func fetchOrCreateSong(mediaItem: MPMediaItem, artist: Artist) throws -> Song? {
        guard let song = try super.fetchOrCreateSong(title: mediaItem.title ?? "(untitled)",
                                                     by: artist) else {
            return nil
        }

        // Create a corresponding SongVersion. These will be merged later.
        do {
            _ = try fetchOrCreateSongVersion(mediaItem: mediaItem, song: song)
        } catch {
            print("Failed to create a song version for \(mediaItem.title ?? "unknown")")
        }

        return song
    }

    open func fetchOrCreateSongVersion(mediaItem: MPMediaItem, song: Song?) throws -> SongVersion? {
        let version = SongVersion(context: context)
        version.comment = mediaItem.comments
        version.duration = mediaItem.playbackDuration
        version.mediaItemPersistentID = "\(mediaItem.persistentID)"
        version.song = song

        if mediaItem.title != song?.title {
            version.alternativeTitle = mediaItem.title
        }

//        if let lyricString = mediaItem.lyrics {
//            let lyrics = Lyrics(context: context)
//            lyrics.text = lyricString
//            version.lyrics = lyrics
//        }

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
#endif
