//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

// swiftlint:disable inclusive_language

public typealias Album = MasterRelease

/// Implemented by elements that have an optional ``releaseDate`` property.
/// Most types will just return  like
public protocol HasReleaseDate: HasTitle {

    /// Get the earliest date that this element was released. For compound
    /// types, like ``MasterRelease``s and ``Song``s, this will be the
    /// earliest release date of their subelements; if they don't have
    /// specific dates, then the compound item's own release date will be
    /// returned.
    var earliestReleaseDate: Date? { get }

    var releaseDate: Date? { get }

}

public protocol HasSubelements {

    associatedtype Subelement

}

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

    /// Get an array of ``HasReleaseDate``-conforming elements, sorted by
    /// their ``HasReleaseDate/earliestReleaseDate``s.
    var chronologically: [HasReleaseDate] {
        self.allObjects
            .compactMap { $0 as? HasReleaseDate }
            .sorted { (leftElement, rightElement) in
                switch (leftElement.earliestReleaseDate, rightElement.earliestReleaseDate) {
                case (nil, nil):
                    return leftElement.displayableTitle < rightElement.displayableTitle
                case (nil, _):
                    return false
                case (_, nil):
                    return true
                default:
                    return leftElement.earliestReleaseDate! < rightElement.earliestReleaseDate!
                }
            }
    }

}
