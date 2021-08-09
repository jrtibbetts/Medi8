//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

public extension ReleaseVersion {

    var songVersions: [SongVersion] {
        return (trackListing?.songVersions?.array as? [SongVersion]) ?? []
    }

}
