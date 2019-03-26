//  Copyright © 2017 Poikile Creations. All rights reserved.

import MediaPlayer
import UIKit
import CoreData

/// A `FetchedResultsModel` for table views.
open class FetchedResultsTableModel: FetchedResultsModel, UITableViewDataSource, UITableViewDelegate {

    /// The table view for which this model is a delegate and data source.
    let tableView: UITableView

    /// Construct a model for a specific table view.
    ///
    /// - parameter tableView: The `UITableView`. The model sets itself as the
    /// table view's delegate and data source.
    /// - parameter context: The managed object context.
    /// - parameter fetchedResultsController: The fetched results controller
    /// that will populate this model with data.
    public init(_ tableView: UITableView,
                context: NSManagedObjectContext,
                fetchedResultsController: NSFetchedResultsController<NSManagedObject>) {
        self.tableView = tableView
        super.init(context: context, fetchedResultsController: fetchedResultsController)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    // MARK: - UITableViewDataSource & UITableViewDelegate

    /// Get the number of sections from the fetched results controller.
    ///
    /// - parameter tableView: The table view.
    ///
    /// - returns: The number of sections.
    open func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }

    /// Get the number of sections from the fetched results controller.
    ///
    /// - parameter tableView: The table view.
    ///
    /// - returns: The number of rows in the specified section.
    open func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(in: section)
    }

    // This default implementation barfs up an assertion failure. You must
    // override it and *not* call `super.tableView(_, cellForRowAt:)`.
    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        preconditionFailure("""
Looks like someone didn't override tableView(_,cellForRowAt:) in the FetchedResultsTableModel.
""")
    }

    open func tableView(_ tableView: UITableView,
                        canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    open func tableView(_ tableView: UITableView,
                        commit editingStyle: UITableViewCell.EditingStyle,
                        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let controller = fetchedResultsController
            let context = controller.managedObjectContext
            context.delete(controller.object(at: indexPath))

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

    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }

    public func tableView(_ tableView: UITableView,
                          sectionForSectionIndexTitle title: String,
                          at index: Int) -> Int {
        return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }

    // MARK: - Fetched results controller

    /// Tell the table view that updates are about to begin.
    public func controllerWillChangeContent(_ controller: FRC) {
        self.tableView.beginUpdates()
    }

    public func controller(_ controller: FRC,
                           didChange sectionInfo: NSFetchedResultsSectionInfo,
                           atSectionIndex sectionIndex: Int,
                           for type: NSFetchedResultsChangeType) {
        let sectionIndices = IndexSet(integer: sectionIndex)

        switch type {
        case .insert:
            tableView.insertSections(sectionIndices, with: .fade)
        case .delete:
            tableView.deleteSections(sectionIndices, with: .fade)
        default:
            return
        }
    }

    public func controller(_ controller: FRC,
                           didChange anObject: Any,
                           at indexPath: IndexPath?,
                           for type: NSFetchedResultsChangeType,
                           newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    public func controllerDidChangeContent(_ controller: FRC) {
        self.tableView.endUpdates()
    }

    // Implementing the above methods to update the table view in response to
    // individual changes may have performance implications if a large number of
    // changes are made simultaneously. If this proves to be an issue, you can
    // instead just implement controllerDidChangeContent: which notifies the
    // delegate that all section and object changes have been processed.

    public func controllerDidChangeContent(controller: FRC) {
        // In the simplest, most efficient, case, reload the table view.
        self.tableView.reloadData()
    }

}
