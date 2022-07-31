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

}
