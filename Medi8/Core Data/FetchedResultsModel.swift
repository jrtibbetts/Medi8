//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData

public typealias ManagedObjectFRC = NSFetchedResultsController<NSManagedObject>
public typealias RequestResultFRC = NSFetchedResultsController<NSFetchRequestResult>

/// A model class that can be used as the base class of collection and table
/// models, backed by a `NSFetchedResultsController`.
open class FetchedResultsModel: NSObject, ManagedObjectContextContainer {

    public var fetchedResultsController: ManagedObjectFRC
    public var moContext: NSManagedObjectContext?

    public init(context: NSManagedObjectContext,
                fetchedResultsController: ManagedObjectFRC) {
        self.moContext = context
        self.fetchedResultsController = fetchedResultsController
    }

    // MARK: - Utility methods for implementations to use

    /// Delete the managed object at a specified path. This will remove it not
    /// only from the model, but from the managed object context! Use with
    /// caution. The context is *not* save()-d afterwards, however, so that's
    /// the responsibility of the caller.
    ///
    /// - parameter indexPath: The location of the element to be deleted.
    open func deleteElement(at indexPath: IndexPath) {
        if let element = self.element(at: indexPath) {
            let context = fetchedResultsController.managedObjectContext
            context.delete(element)
        }
    }

    open func element(at indexPath: IndexPath) -> NSManagedObject? {
        return fetchedResultsController.object(at: indexPath)
    }

    open func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    open func numberOfItems(in section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    open func saveContext() {
        let context = fetchedResultsController.managedObjectContext

        guard context.hasChanges else {
            return
        }

        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error
            // appropriately.
            // fatalError() causes the application to generate a crash
            // log and terminate. You should not use this function in a
            // shipping application, although it may be useful during
            // development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

}
