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

    func testTableModel() {
        let tableView = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0))
        let fetchRequest = NSFetchRequest<MasterRelease>(entityName: "MasterRelease")
        fetchRequest.sortDescriptors = []
        let frc = fetchedResultsController(for: fetchRequest)!
        let model = FetchedResultsTableModel(tableView, context: moContext!, fetchedResultsController: frc as! NSFetchedResultsController<NSManagedObject>)
        XCTAssertTrue(tableView.dataSource === model)
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 14)
    }
    
}
