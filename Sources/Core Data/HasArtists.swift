//
//  File.swift
//  File
//
//  Created by Jason R Tibbetts on 8/7/21.
//

import Foundation

public protocol HasArtists {

    var artists: NSOrderedSet? { get }

}

public extension HasArtists {

    var displayableArtistName: String {
        return artists?.compactMap { ($0 as? Artist)?.name }.joined(separator: ", ") ?? "Unknown"
    }

}
