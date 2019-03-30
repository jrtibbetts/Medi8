//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Medi8
import CoreData
import XCTest

class FetchedResultsModelTests: FetchingTestBase, FetchedResultsProvider {

    var moContext: NSManagedObjectContext? = FetchingTestBase.testingContext

    func importMedia() {
        let mediaImporter = MockMediaImporter(context: FetchingTestBase.testingContext)
        try! mediaImporter.importMedia()
    }

    // MARK: - FetchedResultsProvider

    typealias ManagedObjectType = MasterRelease

    // MARK: - FetchedResultsTableModel Tests

    func testTableModelNumberOfSectionsAndRows() throws {
        importMedia()

        let (tableView, model) = try tableAndModel()
        XCTAssertTrue(tableView.dataSource === model)
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 14)
    }

    func testTableModelDeleteItem() throws {
        importMedia()

        let (tableView, model) = try tableAndModel()
        let path = IndexPath(row: 9, section: 0)
        XCTAssertFalse(model.tableView(tableView, canEditRowAt: path))
        model.tableView(tableView, commit: .delete, forRowAt: path)
        XCTAssertEqual(model.numberOfItems(in: 0), 13)
        tableView.reloadData()
        XCTAssertTrue(tableView.dataSource === model)
        XCTAssertEqual(model.tableView(tableView, numberOfRowsInSection: 0), 13)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 13)
    }

    func testTableModelCell() throws {
        importMedia()

        let (tableView, model) = try tableAndModel()
        let path = IndexPath(row: 9, section: 0)
        _ = model.tableView(tableView, cellForRowAt: path)
    }

    func tableAndModel() throws -> (UITableView, FetchedResultsTableModel) {
        let tableView = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0))
        let fetchRequest = NSFetchRequest<MasterRelease>(entityName: "MasterRelease")
        fetchRequest.sortDescriptors = []
        let frc = try fetchedResultsController(for: fetchRequest)!
        let model = FetchedResultsTableModel(tableView,
                                             context: moContext!,
                                             fetchedResultsController: frc as! ManagedObjectFRC)
        tableView.dataSource = model

        return (tableView, model)
    }

    // MARK: - FetchedResultsCollectionModel Tests

    func testCollectionModelNumberOfSectionsAndItems() throws {
        importMedia()
        
        let (collectionView, model) = try collectionAndModel()
        XCTAssertTrue(collectionView.dataSource === model)
        XCTAssertEqual(collectionView.numberOfSections, 1)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 14)
    }

    func testCollectionModelCell() throws {
        importMedia()

        let (collectionView, model) = try collectionAndModel()
        let path = IndexPath(row: 9, section: 0)
        _ = model.collectionView(collectionView, cellForItemAt: path)
    }

    func collectionAndModel() throws -> (UICollectionView, FetchedResultsCollectionModel) {
        let collectionView = UICollectionView(frame: CGRect(),
                                              collectionViewLayout: UICollectionViewFlowLayout())
        let fetchRequest = NSFetchRequest<MasterRelease>(entityName: "MasterRelease")
        fetchRequest.sortDescriptors = []
        let frc = try fetchedResultsController(for: fetchRequest)!
        let model = FetchedResultsCollectionModel(collectionView,
                                                  context: moContext!,
                                                  fetchedResultsController: frc as! ManagedObjectFRC)
        collectionView.dataSource = model

        return (collectionView, model)
    }

}
