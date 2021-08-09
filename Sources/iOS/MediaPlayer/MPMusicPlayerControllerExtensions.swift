//  Copyright © 2021 Poikile Creations. All rights reserved.

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
