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
