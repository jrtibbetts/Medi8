//  Created by Jason R Tibbetts on 4/10/21.

import Foundation

/// Implemented by entities that have a title, artist name, and songs.
public protocol Album {

    var artistName: String { get }
    var id: UInt64 { get }
    var songs: [Song] { get }
    var title: String { get }

}

public struct MockAlbum: Album {

    public var artistName: String

    public var id: UInt64

    public var songs: [Song] = []

    public var title: String

}
