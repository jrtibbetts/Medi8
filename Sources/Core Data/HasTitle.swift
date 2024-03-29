//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

public protocol HasTitle {

    var title: String? { get }

    var sortTitle: String? { get }

}

public extension HasTitle {

    var displayableSortTitle: String {
        return sortTitle ?? displayableTitle
    }

    var displayableTitle: String {
        return title ?? "Untitled"
    }

}
