//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData

/// A model class that can be used as the base class of collection and table
/// models, backed by a `NSFetchedResultsController`.
open class FetchedResultsModel: NSObject, ManagedObjectContextContainer {

    public typealias ManagedObjectFRC = NSFetchedResultsController<NSManagedObject>
    public typealias RequestResultFRC = NSFetchedResultsController<NSFetchRequestResult>

    public var fetchedResultsController: ManagedObjectFRC
    public var moContext: NSManagedObjectContext?

    public init(context: NSManagedObjectContext,
                fetchedResultsController: ManagedObjectFRC) {
        self.moContext = context
        self.fetchedResultsController = fetchedResultsController
    }

    // MARK: - Utility methods for implementations to use

    open func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    open func numberOfItems(in section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

}
