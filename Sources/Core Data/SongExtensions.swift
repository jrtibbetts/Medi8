//  Created by Jason R Tibbetts on 4/6/21.

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
        return artists?.compactMap { ($0 as? Artist)?.name }.joined(separator: ", ") ?? "Unknown"
    }

    var versionsArray: [SongVersion] {
        return versions?.compactMap { $0 as? SongVersion } ?? []
    }

}

extension Song: HasTitle {

}

public extension SongVersion {

    static func withMediaID(_ persistentId: Int64?,
                            context: NSManagedObjectContext) -> SongVersion? {
        guard let persistentId = persistentId else {
            return nil
        }

        let request: NSFetchRequest<SongVersion> = SongVersion.fetchRequest(sortDescriptors: [(\SongVersion.mediaItemPersistentID).sortDescriptor()],
                                                                            predicate: NSPredicate(format: "mediaItemPersistentID = \(persistentId)"))

        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to find a song version with a persistentID of \(persistentId): \(error.localizedDescription)")
            return nil
        }
    }

    var displayableArtistName: String {
        return artists?.compactMap { ($0 as? Artist)?.name }.joined(separator: ", ") ?? "Unknown"
    }

    var displayableTitle: String {
        return alternativeTitle ?? song?.displayableTitle ?? "Untitled"
    }

}
