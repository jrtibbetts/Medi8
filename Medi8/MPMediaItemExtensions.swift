//  Created by Jason R Tibbetts on 4/1/21.

import Foundation
import MediaPlayer

public extension MPMediaItem {

    var sortAlbumArtist: String {
        return (value(forProperty: "sortAlbumArtist") as? String) ?? title ?? "[no artist]"
    }

    var sortAlbumTitle: String {
        return (value(forProperty: "sortAlbumTitle") as? String) ?? title ?? "[untitled]"
    }

    var sortArtist: String {
        return (value(forProperty: "sortArtist") as? String) ?? title ?? "[no artist]"
    }

    var sortTitle: String {
        return (value(forProperty: "sortTitle") as? String) ?? title ?? "[untitled]"
    }

}
