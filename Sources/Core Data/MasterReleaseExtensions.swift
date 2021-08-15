//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

public typealias Album = MasterRelease

public extension MasterRelease {

    /// Get the earliest date that this title was released. This will be the
    /// earliest of its release versions' release date; if none of them has a
    /// release date specified, it will be the master release's own
    /// releaseDate.
    var earliestReleaseDate: Date? {
        return versions?
            .compactMap { ($0 as? ReleaseVersion)?.releaseDate?.date }
            .sorted()
            .first ?? releaseDate?.date
    }

}

extension MasterRelease: HasArtists, HasTitle {
    
}

public extension NSSet {

    /// Get a list of ``MasterRelease``s, sorted alphabetically by their
    /// ``MasterRelease/displayableTitle``s.
    var alphabetically: [MasterRelease] {
        self.allObjects
            .compactMap { $0 as? MasterRelease }
            .sorted { $0.displayableTitle < $1.displayableTitle }
    }

    /// Get an array of ``MasterRelease``s, sorted by their
    /// ``MasterRelease/earliestReleaseDate``s.
    var chronologically: [MasterRelease] {
        self.allObjects
            .compactMap { $0 as? MasterRelease }
            .sorted { (leftRelease, rightRelease) in
                switch (leftRelease.earliestReleaseDate, rightRelease.earliestReleaseDate) {
                case (nil, nil):
                    return leftRelease.displayableTitle < rightRelease.displayableTitle
                case (nil, _):
                    return false
                case (_, nil):
                    return true
                default:
                    return leftRelease.earliestReleaseDate! < rightRelease.earliestReleaseDate!
                }
            }
    }

}
