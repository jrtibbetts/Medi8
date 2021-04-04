//  Created by Jason R Tibbetts on 3/31/21.

import Foundation
import MediaPlayer

public extension MPMediaItemCollection {

    var artist: String {
        return representativeItem?.albumArtist ?? "[unknown]"
    }

    var title: String {
        return representativeItem?.albumTitle ?? "[untitled]"
    }

}
