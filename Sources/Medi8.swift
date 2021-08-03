//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation
import Stylobate

/// An empty class that can be used to get the Medi8 bundle.
public class Medi8: NSObject {

    public static var bundle = Stylobate.resourceBundle(named: "Medi8_Medi8",
                                                        sourceBundle: Bundle(for: Medi8.self))

}
