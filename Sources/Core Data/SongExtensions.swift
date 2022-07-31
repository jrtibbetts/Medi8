//  Copyright © 2021 Poikile Creations. All rights reserved.

import CoreData
import Foundation

public extension Song {

    static func named(_ title: String,
                      byArtist artist: String,
                      context: NSManagedObjectContext) -> [Song]? {
        guard let artist = Artist.named(artist, context: context) else {
            return nil
        }

        return artist.songs?.compactMap { $0 as? Song }.filter { $0.title == title }
    }

    var displayableArtistName: String {
        return artists?.compactMap { ($0 as? Artist)?.name }.joined(separator: ", ") ?? "Unknown Artist"
    }

    var displayableSortArtistName: String {
        return artists?.compactMap { ($0 as? Artist)?.sortName }.joined(separator: ", ") ?? "Unknown Artist"
    }

    var id: String {
        return displayableSortTitle + "/" + displayableSortArtistName
    }

    var versionsArray: [SongVersion] {
        return versions?.compactMap { $0 as? SongVersion } ?? []
    }

}

extension Song: HasTitle {

}

public extension SongVersion {

    static func withMediaID(_ persistentId: Int64?,
                            context: NSManagedObjectContext) throws -> SongVersion? {
        guard let persistentId = persistentId else {
            return nil
        }

        let byMediaItemId = (\SongVersion.mediaItemPersistentID).sortDescriptor()
        let matchMediaItemId = NSPredicate(format: "mediaItemPersistentID = \(persistentId)")
        let request: NSFetchRequest<SongVersion> = SongVersion.fetchRequest(sortDescriptors: [byMediaItemId],
                                                                            predicate: matchMediaItemId)

        return try context.fetch(request).first
    }

    var displayableArtistName: String {
        return artists?.compactMap { ($0 as? Artist)?.name }.joined(separator: ", ") ?? "Unknown"
    }

    var displayableTitle: String {
        return alternativeTitle ?? song?.displayableTitle ?? "Untitled"
    }

}
