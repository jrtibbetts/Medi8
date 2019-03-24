//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import Medi8
import CoreData
import XCTest

public protocol FetchedResultsModelTestBase {

    var moContext: NSManagedObjectContext? { get set }

    func model() -> FetchedResultsModel

    func testNumberOfSections()

    func testNumberOfItemsInSection()

}

public extension FetchedResultsModelTestBase {

    public func testNumberOfSections() {
        // Populate the testing context.
        let artist1 = IndividualArtist(context: moContext!)
        artist1.name = "Pondiferous Flatulence"
        artist1.sortName = "Flatulence, Pondiferous"
        let artist2 = IndividualArtist(context: moContext!)
        artist2.name = "Pancake Batter"
        artist2.sortName = "Batter, Pancake"

        // Set up the fetched results controller.
        let request = NSFetchRequest<IndividualArtist>(entityName: "IndividualArtist")
        request.sortDescriptors = ["sortName".sortDescriptor()]
//        let frc = NSFetchedResultsController<IndividualArtist>(fetchRequest: request, managedObjectContext: moContext!, sectionNameKeyPath: "sortName", cacheName: nil)
        let testModel = model()
        XCTAssertEqual(testModel.numberOfSections(), 2)
        XCTAssertEqual(testModel.numberOfItems(in: 0), 1)
    }

}
