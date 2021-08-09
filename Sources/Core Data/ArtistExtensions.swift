//  Copyright © 2021 Poikile Creations. All rights reserved.

import CoreData
import Foundation

public extension Artist {

    #if !os(macOS)
    internal convenience init(_ artistName: MediaPlayerImporter.ArtistName, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = artistName.name
        self.sortName = artistName.sortName
    }
    #endif

    static func named(_ name: String,
                      context: NSManagedObjectContext) -> Artist? {
        let sortByName = (\Artist.name).sortDescriptor()
        let predicate = NSPredicate(format: "name = '\(name)'")
        let fetchRequest = Artist.fetchRequest(sortDescriptors: [sortByName],
                                               predicate: predicate)

        do {
            return try context.fetch(fetchRequest).first as? Artist
        } catch {
            print("Failed to look up an artist named '\(name)': \(error.localizedDescription)")
            return nil
        }
    }

}

extension Artist: HasName {

}
