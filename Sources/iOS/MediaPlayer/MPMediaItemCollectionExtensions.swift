//  Copyright © 2021 Poikile Creations. All rights reserved.

import MediaPlayer

public extension MPMediaItemCollection {

    var title: String? {
        return self.value(forKey: MPMediaPlaylistPropertyName) as? String
    }

}
