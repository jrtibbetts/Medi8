//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData
import Stylobate

// swiftlint:disable inclusive_language

/// Implemented by classes that populate a Core Data context with media info.
open class Medi8Importer: NSObject {

    open weak var delegate: MediaImporterDelegate?

    /// The managed object context into which the data will be imported.
    open var context: NSManagedObjectContext

    public init(_ context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }

    // MARK: - Artists

    /// Fetch or create an `Artist`.
    ///
    /// - parameter name: The artist's name.
    /// - parameter sortName: The artist's name for sorting purposes. If it's
    ///   `nil`, then the regular name will be used instead.
    ///
    /// - returns: A new or fetched `Artist` with the given name.
    open func fetchOrCreateArtist(named name: String,
                                  sortName: String? = nil) throws -> IndividualArtist? {
        let request: NSFetchRequest<IndividualArtist> = IndividualArtist.fetchRequest()
        request.sortDescriptors = [(\IndividualArtist.sortName).sortDescriptor()]
        request.predicate = NSPredicate(format: "name = %@", name)

        return try context.fetchOrCreate(withRequest: request) { (artist) in
            print("Creating an artist named \(name)")
            artist.name = name
            artist.sortName = sortName ?? name
        }
    }

    // MARK: - Releases

    /// Fetch or create a `MasterRelease`. This will also create a single
    /// `ReleaseVersion` and `TrackListing` for it.
    ///
    /// - parameter name: The release title. This will also be used as its
    ///   `sortTitle`.
    /// - parameter artists: The artists who created the release.
    /// - parameter releaseDate: An optional `Date` of when the release was
    ///   first, well, released.
    ///
    /// - returns: A new or fetched `MasterRelease`.
    open func fetchOrCreateMasterRelease(named name: String,
                                         by artists: [Artist]? = nil,
                                         releaseDate: Date? = Date()) throws -> MasterRelease? {
        let request: NSFetchRequest<MasterRelease> = MasterRelease.fetchRequest()
        request.sortDescriptors = [(\MasterRelease.sortTitle).sortDescriptor(),
                                   (\MasterRelease.title).sortDescriptor()]
        request.predicate = NSPredicate(format: "title = %@", name)

        return try context.fetchOrCreate(withRequest: request) { (masterRelease) in
            masterRelease.title = name
            masterRelease.sortTitle = name

            if let artists = artists {
                masterRelease.addToArtists(NSOrderedSet(array: artists))
            }

            do {
                if let releaseVersion = try fetchOrCreateReleaseVersion(releaseDate: releaseDate) {
                    releaseVersion.parentRelease = masterRelease
                }
            } catch {
                print("Failed to create a release version: \(error.localizedDescription)")
            }
        }
    }

    open func fetchOrCreateReleaseVersion(releaseDate: Date?) throws -> ReleaseVersion? {
        let releaseVersion = ReleaseVersion(context: context)
        releaseVersion.trackListing = TrackListing(context: context)

        if let releaseDate = releaseDate {
            let releaseDateObject = ReleaseDate(context: context)
            releaseDateObject.date = releaseDate
            releaseVersion.releaseDate?.adding(releaseDateObject)
        }

        return releaseVersion
    }

    // MARK: - Songs

    /// Fetch or create a `Song`. This will also create a `Recording` for it.
    ///
    ///  - parameter name: The song title.
    ///  - parameter artist: The artist who performed the song.
    open func fetchOrCreateSong(title: String,
                                by artist: Artist?) throws -> Song? {
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.sortDescriptors = [(\Song.title).sortDescriptor()]
        request.predicate = NSPredicate(format: "title = %@", title)

        return try context.fetchOrCreate(withRequest: request) { (song) in
            song.title = title
            artist?.addToSongs(song)
            Recording(context: context).addToSongs(song)
        }
    }

    open func fetchOrCreateSongVersion(mediaId mediaItemPersistentID: Int64,
                                       song: Song?) throws -> SongVersion? {
        guard let songVersionSet = song?.versions as? Set<SongVersion> else {
            return SongVersion(context: context)
        }

        let songVersions = Array<SongVersion>(songVersionSet)

        if let existingSongVersion = songVersions.first(where: { $0.mediaItemPersistentID == mediaItemPersistentID }) {
            return existingSongVersion
        } else {
            let songVersion = SongVersion(context: context)
            songVersion.mediaItemPersistentID = mediaItemPersistentID
            songVersion.song = song

            return songVersion
        }
    }

}

/// Implemented by classes that want to keep track of the progress of the media
/// importer. The importer should ensure that delegate methods are called on
/// the main thread, but this is not guaranteed.
public protocol MediaImporterDelegate: AnyObject {

    func willStartImporting()

    func didStartImporting()

    func willFinishImporting()

    func didFinishImporting(with error: Any?)

}

public extension MediaImporterDelegate {

    func willStartImporting() { }

    func didStartImporting() { }

    func willFinishImporting() { }

    func didFinishImporting(with error: Any?) { }

}
