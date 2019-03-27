//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData
import UIKit

open class FetchedResultsCollectionModel: FetchedResultsModel,
    NSFetchedResultsControllerDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate {

    weak var collectionView: UICollectionView!

    public init(_ collectionView: UICollectionView,
                context: NSManagedObjectContext,
                fetchedResultsController: ManagedObjectFRC) {
        self.collectionView = collectionView
        super.init(context: context, fetchedResultsController: fetchedResultsController)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.fetchedResultsController.delegate = self
    }

    // MARK: - UICollectionViewDataSource & UICollectionViewDelegate

    open func collectionView(_ collectionView: UICollectionView,
                             numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(in: section)
    }

    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    // MARK: - Fetched results controller

    open func controller(_ controller: RequestResultFRC,
                         didChange sectionInfo: NSFetchedResultsSectionInfo,
                         atSectionIndex sectionIndex: Int,
                         for type: NSFetchedResultsChangeType) {
        let sectionIndices = IndexSet(integer: sectionIndex)

        if type == .insert {
            collectionView.insertSections(sectionIndices)
            collectionView.reloadData()
        }
    }

    open func controller(_ controller: RequestResultFRC,
                         didChange anObject: Any,
                         at indexPath: IndexPath?,
                         for type: NSFetchedResultsChangeType,
                         newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            break  // do nothing
        case .delete:
            if let indexPath = indexPath {
                deleteElement(at: indexPath)
                saveContext()
                collectionView.reloadData()
            }
        case .update:
            collectionView.reloadItems(at: [indexPath!])
        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        }
    }

}
