//  Created by Jason R Tibbetts on 3/19/21.

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

    public func allArtists() -> [Artist]? {
        return try? context.fetch(Self.allArtistsRequest)
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

    public func allSongs() -> [Song]? {
        return try? context.fetch(Self.allSongsRequest)
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

    public func songVersion(iTunesPersistentID: Int64) -> SongVersion? {
        let fetchRequest: NSFetchRequest<SongVersion> = SongVersion.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mediaItemPersistentID = %@", iTunesPersistentID)

        return try? context.fetch(fetchRequest).first
    }

    // MARK: - Releases

    public static var allMasterReleasesRequest: NSFetchRequest<MasterRelease> = {
        let sortBySortTitleAscending = (\MasterRelease.sortTitle).sortDescriptor(ascending: true)
        let request: NSFetchRequest<MasterRelease> = MasterRelease.fetchRequestForAll(sortedBy: [sortBySortTitleAscending])

        return request
    }()

    public func allMasterReleases() -> [MasterRelease]? {
        return try? context.fetch(Self.allMasterReleasesRequest)
    }

    public func allAlbums() -> [MasterRelease]? {
        return allMasterReleases()
    }

}

public class MockMediaLibrary: MediaLibrary {

    public init() {
        super.init(context: Medi8PersistentContainer.sharedInMemoryContext)

        loadSongs()
        loadPlaylists()
    }

    public func loadSongs() {
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

        for songData: (title: String, duration: Double, comment: String) in
                [("Cascade", 266.0, comment),
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
                ] {
            let song = Song(context: context)
            song.title = songData.title
            song.artists = [siouxsie]
            song.lyrics = nil

            let songVersion = SongVersion(context: context)
            songVersion.comment = songData.comment
            songVersion.duration = songData.duration
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

    public func loadPlaylists() {
        let playlist = Playlist(context: context)
        playlist.title = "Siouxsie Hits"
    }

}
