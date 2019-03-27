//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData
import Foundation

public extension NSManagedObjectContext {

    /// Fetch (using a specified request) or create (using an initialization
    /// block) an `NSManagedObject` subtype.
    ///
    /// - parameter request: The fetch request. This should already have its
    ///   predicate, sort order, and other properties set before it's passed
    ///   in.
    /// - parameter initialize: A block that's called to create a new managed
    ///   object if no matching one was found.
    func fetchOrCreateManagedObject<T: NSManagedObject>(with request: NSFetchRequest<NSFetchRequestResult>,
                                                        initialize: (NSManagedObjectContext) -> T) throws -> T {
        // Fetch.................................or create.
        return try fetch(request).first as? T ?? initialize(self)
    }

}
