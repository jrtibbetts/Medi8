//  Created by Jason R Tibbetts on 4/5/21.

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
