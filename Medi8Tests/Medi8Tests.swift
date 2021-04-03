//  Created by Jason R Tibbetts on 4/3/21.

@testable import Medi8
import Stylobate
import XCTest

public class Medi8Tests: XCTestCase {

    public static var resourceBundle = Stylobate.resourceBundle(named: "Medi8_Medi8Tests",
                                                                sourceBundle: Bundle(for: Medi8Tests.self))

    func testStylobateResourceBundle() {
        let resources = Self.resourceBundle
        XCTAssertNotNil(resources.url(forResource: "MockData", withExtension: "json"))
    }

}
