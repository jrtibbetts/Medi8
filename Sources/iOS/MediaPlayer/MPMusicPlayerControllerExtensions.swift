//  Created by Jason R Tibbetts on 4/15/21.

import Foundation
import MediaPlayer

#if os(iOS)

extension MPMusicPlayerController: MediaPlayer {

    public func setQueue(with songVersions: [MPMediaItem]) {
        setQueue(with: MPMediaItemCollection(items: songVersions))
    }

    public var nowPlayingSong: MPMediaItem? {
        return nowPlayingItem
    }

}

#endif
