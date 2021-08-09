//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

public protocol HasArtists {

    var artists: NSOrderedSet? { get }

}

public extension HasArtists {

    var displayableArtistName: String {
        return artists?.compactMap { ($0 as? Artist)?.name }.joined(separator: ", ") ?? "Unknown"
    }

}
