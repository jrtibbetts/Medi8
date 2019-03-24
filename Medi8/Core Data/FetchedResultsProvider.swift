//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData

/// Implemented by objects that have an `NSFetchedResultsController`.
public protocol FetchedResultsProvider: ManagedObjectContextContainer, NSFetchedResultsControllerDelegate {
    
    associatedtype ManagedObjectType: NSManagedObject
    
    /// Set up the fetched results controller. This has a default
    /// implementation, so implementers of this protocol usually don't need to
    /// provide their own implementation.
    func fetchedResultsController(for fetchRequest: NSFetchRequest<ManagedObjectType>) -> NSFetchedResultsController<ManagedObjectType>
    
}

extension FetchedResultsProvider {
    
    /// Configure the fetched results controller with a fetch request, then
    /// perform a fetch on it.
    ///
    /// - parameter fetchRequest: The request that's been configured with the
    ///   desired sort order and predicate.
    public func fetchedResultsController(for fetchRequest: NSFetchRequest<ManagedObjectType>) -> NSFetchedResultsController<ManagedObjectType> {
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: moContext!,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil /* "Master" */)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return fetchedResultsController
    }
    
}
