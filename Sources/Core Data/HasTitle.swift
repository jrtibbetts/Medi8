//  Created by Jason R Tibbetts on 8/5/21.

import Foundation

public protocol HasTitle {

    var title: String? { get }

    var sortTitle: String? { get }

}

public extension HasTitle {

    var displayableTitle: String {
        return title ?? "Untitled"
    }

}
