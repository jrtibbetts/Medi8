//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

/// Implemented by classes that have an ordered set of `Artist` entities. This
/// can include core data entities that have an ordered to-many relationship
/// with `Artist`s.
public protocol HasArtists {

    /// The ordered set of artists. The particular ordering is not defined here.
    var artists: NSOrderedSet? { get }

    /// The concatenated name of all the artists.
    var artistName: String { get }

}

extension HasArtists {

    /// A comma-separated concatenation of the artist names, or an empty string
    /// if there aren't any artists.
    public var artistName: String {
        if let artistNames: [String] = artists?.compactMap({ ($0 as! Artist).name }) {
            return artistNames.joined(separator: ", ")
        } else {
            return ""
        }
    }

}

extension Song: HasArtists {

}

extension MasterRelease: HasArtists {

}
