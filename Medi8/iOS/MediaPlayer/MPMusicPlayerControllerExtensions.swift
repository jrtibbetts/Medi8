//  Created by Jason R Tibbetts on 4/15/21.

import Foundation
import MediaPlayer

#if os(iOS)

extension MPMusicPlayerController: MediaPlayer {

    public func setQueue(with songs: [Song]) {
        if let mediaItems = songs as? [MPMediaItem] {
            setQueue(with: MPMediaItemCollection(items: mediaItems))
        }
    }

    public var nowPlayingSong: Song? {
        return nowPlayingItem
    }

}

#endif
