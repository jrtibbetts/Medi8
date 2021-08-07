//  Created by Jason R Tibbetts on 8/5/21.

import MediaPlayer

public extension MPMediaItemCollection {

    var title: String? {
        return self.value(forKey: MPMediaPlaylistPropertyName) as? String
    }

}
