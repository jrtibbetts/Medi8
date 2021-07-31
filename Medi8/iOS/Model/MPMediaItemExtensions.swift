//  Created by Jason R Tibbetts on 4/1/21.

import Foundation
import MediaPlayer

#if os(iOS)

public extension MPMediaItem {

    var sortAlbumArtist: String {
        return (value(forProperty: "sortAlbumArtist") as? String) ?? albumArtist ?? "[no artist]"
    }

    var sortAlbumTitle: String {
        return (value(forProperty: "sortAlbumTitle") as? String) ?? albumTitle ?? "[untitled]"
    }

    var sortArtist: String {
        return (value(forProperty: "sortArtist") as? String) ?? "[no artist]"
    }

    var sortTitle: String {
        return (value(forProperty: "sortTitle") as? String) ?? title ?? "[untitled]"
    }

}

extension MPMediaItem: Song {

    public var albumArtistName: String? {
        return artistName
    }

    public var albumID: UInt64 {
        return albumPersistentID
    }

    public var artistName: String? {
        return artist
    }

    public var id: UInt64 {
        return persistentID
    }

    public var images: [Artwork]? {
        if let artwork = artwork {
            return [artwork]
        } else {
            return nil
        }
    }

    public var sortArtistName: String {
        return sortArtist
    }

    public var songTitle: String {
        return title ?? ""
    }

}

#endif
