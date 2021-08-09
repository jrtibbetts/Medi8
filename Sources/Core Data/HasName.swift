//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

public protocol HasName {

    var name: String? { get }

    var sortName: String? { get }

}

public extension HasName {
    
    var displayableName: String {
        return name ?? "Unnamed Artist"
    }
    
}
