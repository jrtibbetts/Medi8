//  Created by Jason R Tibbetts on 3/31/21.

import Foundation
import MediaPlayer

#if os(iOS)

public extension MPMediaItemCollection {

    var artist: String {
        return representativeItem?.albumArtist ?? "[unknown]"
    }

    var sortArtist: String {
        return representativeItem?.sortAlbumArtist ?? "No artist"
    }

    var title: String {
        return representativeItem?.albumTitle ?? "[untitled]"
    }

    var sortTitle: String {
        return representativeItem?.sortAlbumTitle ?? "Untitled"
    }

}

extension MPMediaItemCollection: Album {

    public var artistName: String {
        return artist
    }

    public var id: UInt64 {
        return persistentID
    }

    public var songs: [Song] {
        return items
    }

}

extension MPMediaItemCollection: Playlist {

}

#endif
