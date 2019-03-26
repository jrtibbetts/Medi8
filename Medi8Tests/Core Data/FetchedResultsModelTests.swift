//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Medi8
import CoreData
import XCTest

class FetchedResultsModelTests: FetchingTestBase, FetchedResultsProvider {

    typealias ManagedObjectType = MasterRelease

    var moContext: NSManagedObjectContext? = FetchingTestBase.testingContext

    override class func setUp() {
        let mediaImporter = MockMediaImporter(context: FetchingTestBase.testingContext)
        try! mediaImporter.importMedia()
    }

    func testTableModelNumberOfSectionsAndRows() {
        let (tableView, model) = tableAndModel()
        XCTAssertTrue(tableView.dataSource === model)
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 14)

        let path = IndexPath(row: 9, section: 0)
        XCTAssertFalse(model.tableView(tableView, canEditRowAt: path))
        model.tableView(tableView, commit: .delete, forRowAt: path)
        XCTAssertEqual(model.numberOfItems(in: 0), 13)
        tableView.reloadData()
        XCTAssertTrue(tableView.dataSource === model)
        XCTAssertEqual(model.tableView(tableView, numberOfRowsInSection: 0), 13)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 13)
    }

    func tableAndModel() -> (UITableView, FetchedResultsTableModel) {
        let tableView = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0))
        let fetchRequest = NSFetchRequest<MasterRelease>(entityName: "MasterRelease")
        fetchRequest.sortDescriptors = []
        let frc = fetchedResultsController(for: fetchRequest)!
        let model = FetchedResultsTableModel(tableView, context: moContext!, fetchedResultsController: frc as! NSFetchedResultsController<NSManagedObject>)
        tableView.dataSource = model

        return (tableView, model)
    }

    func testCollectionModelNumberOfSectionsAndItems() {
        let (collectionView, model) = collectionAndModel()
        XCTAssertTrue(collectionView.dataSource === model)
        XCTAssertEqual(collectionView.numberOfSections, 1)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 14)
    }

    func collectionAndModel() -> (UICollectionView, FetchedResultsCollectionModel) {
        let collectionView = UICollectionView(frame: CGRect(),
                                              collectionViewLayout: UICollectionViewFlowLayout())
        let fetchRequest = NSFetchRequest<MasterRelease>(entityName: "MasterRelease")
        fetchRequest.sortDescriptors = []
        let frc = fetchedResultsController(for: fetchRequest)!
        let model = FetchedResultsCollectionModel(collectionView, context: moContext!, fetchedResultsController: frc as! NSFetchedResultsController<NSManagedObject>)
        collectionView.dataSource = model

        return (collectionView, model)
    }

}
