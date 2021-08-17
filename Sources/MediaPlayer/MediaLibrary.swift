//  Copyright © 2021 Poikile Creations. All rights reserved.

import CoreData
import MediaPlayer
import SwiftUI

open class MediaLibrary: ObservableObject {

    @Published public var finishedImporting: Bool = true

    public var context: NSManagedObjectContext

    #if !os(macOS)
    @Published public var authStatus: MPMediaLibraryAuthorizationStatus = .authorized
    #endif

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Artists

    public static var allArtistsRequest: NSFetchRequest<Artist> = {
        let request: NSFetchRequest<Artist> = Artist.fetchRequestForAll()
        request.sortDescriptors = [(\Artist.sortName).sortDescriptor(ascending: true)]

        return request
    }()

    public var artists: [Artist] {
        return (try? context.fetch(Self.allArtistsRequest)) ?? []
    }

    public func artist(_ name: String) -> Artist? {
        let fetchRequest: NSFetchRequest<Artist> = Artist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)

        return try? context.fetch(fetchRequest).first
    }

    public func artist(sortName: String) -> Artist? {
        let fetchRequest: NSFetchRequest<Artist> = Artist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sortName = %@ || name = %@", sortName, sortName)

        return try? context.fetch(fetchRequest).first
    }

    // MARK: - Songs

    public static var allSongsRequest: NSFetchRequest<Song> = {
        let sortBySortTitleAscending = (\Song.sortTitle).sortDescriptor(ascending: true)
        let request: NSFetchRequest<Song> = Song.fetchRequestForAll(sortedBy: [sortBySortTitleAscending])

        return request
    }()

    public var songs: [Song] {
        return (try? context.fetch(Self.allSongsRequest)) ?? []
    }

    public func song(_ title: String) -> Song? {
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)

        return try? context.fetch(fetchRequest).first
    }

    public func song(sortTitle: String) -> Song? {
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sortTitle = %@ || title = %@", sortTitle, sortTitle)

        return try? context.fetch(fetchRequest).first
    }

    // MARK: - SongVersions

    public static var allSongVersionsRequest: NSFetchRequest<SongVersion> = {
        let sortBySortTitleAscending = (\SongVersion.song?.sortTitle).sortDescriptor(ascending: true)
        let sortByIdAscending = (\SongVersion.mediaItemPersistentID).sortDescriptor(ascending: true)
        let request: NSFetchRequest<SongVersion> = SongVersion.fetchRequestForAll(sortedBy: [sortBySortTitleAscending, sortByIdAscending])

        return request
    }()

    public var songVersions: [SongVersion] {
        return (try? context.fetch(Self.allSongVersionsRequest)) ?? []
    }

    public func songVersion(iTunesPersistentID: Int64) -> SongVersion? {
        let fetchRequest: NSFetchRequest<SongVersion> = SongVersion.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mediaItemPersistentID = %@", iTunesPersistentID)

        return try? context.fetch(fetchRequest).first
    }

    // MARK: - Releases

    public static var allMasterReleasesRequest: NSFetchRequest<MasterRelease> = {
        let sortBySortTitleAscending = (\MasterRelease.sortTitle).sortDescriptor(ascending: true)
        let sortByTitleAscending = (\MasterRelease.title).sortDescriptor(ascending: true)
        let request: NSFetchRequest<MasterRelease> = MasterRelease.fetchRequestForAll(sortedBy: [sortBySortTitleAscending, sortByTitleAscending])

        return request
    }()

    public var masterReleases: [MasterRelease] {
        return (try? context.fetch(Self.allMasterReleasesRequest)) ?? []
    }

    public var albums: [MasterRelease] {
        return masterReleases
    }

    // MARK: - Playlists

    public static var allPlaylistsRequest: NSFetchRequest<Playlist> = {
        let sortBySortTitleAscending = (\Playlist.sortTitle).sortDescriptor(ascending: true)
        let sortByTitleAscending = (\Playlist.title).sortDescriptor(ascending: true)
        let request: NSFetchRequest<Playlist> = Playlist.fetchRequestForAll(sortedBy: [sortBySortTitleAscending, sortByTitleAscending])

        return request
    }()

    public var playlists: [Playlist]? {
        return try? context.fetch(Self.allPlaylistsRequest)
    }

}
