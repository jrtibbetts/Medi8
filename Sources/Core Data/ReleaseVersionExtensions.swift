//
//  File.swift
//  File
//
//  Created by Jason R Tibbetts on 8/8/21.
//

import Foundation

public extension ReleaseVersion {

    var songVersions: [SongVersion] {
        return (trackListing?.songVersions?.array as? [SongVersion]) ?? []
    }

}
