//  Created by Jason R Tibbetts on 8/4/21.

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
