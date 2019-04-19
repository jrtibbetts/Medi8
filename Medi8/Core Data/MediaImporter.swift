//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData
import Stylobate

/// Implemented by classes that populate a Core Data context with media info.
public protocol MediaImporter {

    /// The managed object context into which the data will be imported.
    var context: NSManagedObjectContext { get }

    /// Implement all of your import logic in here.
    func importMedia() throws

}

public extension MediaImporter {

    /// Fetch or create an `Artist`.
    ///
    /// - parameter name: The artist's name.
    /// - parameter sortName: The artist's name for sorting purposes. If it's
    ///   `nil`, then the regular name will be used instead.
    ///
    /// - returns: A new or fetched `Artist` with the given name.
    func fetchOrCreateArtist(named name: String, sortName: String? = nil) throws -> Artist? {
        let request: NSFetchRequest<NSFetchRequestResult> = Artist.fetchRequest()
        request.sortDescriptors = [(\IndividualArtist.sortName).sortDescriptor()]
        request.predicate = NSPredicate(format: "name = %@", name)

        return try context.fetchOrCreateManagedObject(with: request) { (context) -> Artist in
            print("Creating an artist named \(name)")
            let artist = IndividualArtist(context: context)
            artist.name = name
            artist.sortName = sortName ?? name

            return artist
        }
    }

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
    func fetchOrCreateMasterRelease(named name: String,
                                    by artists: [Artist]? = nil,
                                    releaseDate: Date? = Date()) throws -> MasterRelease? {
        let request: NSFetchRequest<NSFetchRequestResult> = MasterRelease.fetchRequest()
        request.sortDescriptors = [(\MasterRelease.sortTitle).sortDescriptor(),
                                   (\MasterRelease.title).sortDescriptor()]
        request.predicate = NSPredicate(format: "title = %@", name)

        return try context.fetchOrCreateManagedObject(with: request) { (context) -> MasterRelease in
            let masterRelease = MasterRelease(context: context)
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

            }

            return masterRelease
        }
    }

    func fetchOrCreateReleaseVersion(releaseDate: Date?) throws -> ReleaseVersion? {
        let releaseVersion = ReleaseVersion(context: context)
        releaseVersion.trackListing = TrackListing(context: context)

        if let releaseDate = releaseDate {
            let releaseDateObject = ReleaseDate(context: context)
            releaseDateObject.date = releaseDate
            releaseVersion.releaseDate?.adding(releaseDateObject)
        }

        return releaseVersion
    }

    /// Fetch or create a `Song`. This will also create a `Recording` for it.
    ///
    ///  - parameter name: The song title.
    ///  - parameter artist: The artist who performed the song.
    func fetchOrCreateSong(named name: String, by artist: Artist) throws -> Song? {
        let request: NSFetchRequest<NSFetchRequestResult> = Song.fetchRequest()
        request.sortDescriptors = [(\Song.title).sortDescriptor()]
        request.predicate = NSPredicate(format: "title = %@", name)

        return try context.fetchOrCreateManagedObject(with: request) { (context) -> Song in
            let song = Song(context: context)
            song.title = name
            artist.addToSongs(song)
            Recording(context: context).addToSongs(song)

            return song
        }
    }

}

/// Implemented by classes that want to keep track of the progress of the media
/// importer. The importer should ensure that delegate methods are called on
/// the main thread, but this is not guaranteed.
public protocol MediaImporterDelegate: class {

    /// Called when the import is about to begin.
    func willStartImporting()

    /// Called when the import has begun.
    func didStartImporting()

    /// Called when the import is about to be finished.
    func willFinishImporting()

    /// Called when the import has finished.
    func didFinishImporting(with error: Any?)

}

public extension MediaImporterDelegate {

    func willStartImporting() {
        // By default, do nothing.
    }

    func didStartImporting() {
        // By default, do nothing.
    }

    func willFinishImporting() {
        // By default, do nothing.
    }

    func didFinishImporting(with error: Any?) {
        // By default, do nothing.
    }

}

//public extension String {
//
//    /// Get an `NSSortDescriptor` whose key is this string. This makes it as
//    /// easy as calling `"widgetCount".sortDescriptor(ascending: false)`.
//    ///
//    /// - parameter ascending: `true` if the sort order should be ascending.
//    ///   The default is `true`.
//    public func sortDescriptor(ascending: Bool = true) -> NSSortDescriptor {
//        return NSSortDescriptor(key: self, ascending: ascending)
//    }
//
//}
//
public extension KeyPath {

    /// Get an `NSSortDescriptor` whose key is this key path. Calling it like
    /// `(\WidgetHolder.widgetCount).sortDescriptor(ascending: false)`
    ///
    /// - parameter ascending: `true` if the sort order should be ascending.
    ///   The default is `true`.
    func sortDescriptor(ascending: Bool = true) -> NSSortDescriptor {
        return NSSortDescriptor(keyPath: self, ascending: ascending)
    }

}
