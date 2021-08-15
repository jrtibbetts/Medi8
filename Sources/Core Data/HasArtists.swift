//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

/// Implemented by elements that have an unordered set of `Artist`s.
public protocol HasArtists {

    var artists: NSOrderedSet? { get }

}

public extension HasArtists {

    /// The names of the artists, concatenated with a comma. The order of the
    /// artists is the same as the order in which they were added to the
    /// element.
    ///
    /// At some point, this should be expanded to allow custom separators, or
    /// even mixed separators, such as "Elvis Costello and The Attractions
    /// feat. Johnny Cash."
    var displayableArtistName: String {
        return artists?.compactMap { ($0 as? Artist)?.name }.joined(separator: ", ") ?? "Unknown"
    }

}
