//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

extension ReleaseVersion: HasTitle {

    public var title: String? {
        return alternativeTitle ?? parentRelease?.title
    }

    public var sortTitle: String? {
        return alternativeSortTitle ?? parentRelease?.sortTitle
    }

}

public extension ReleaseVersion {

    var songVersions: [SongVersion] {
        return (trackListing?.songVersions?.array as? [SongVersion]) ?? []
    }

}
