//  Copyright © 2021 Poikile Creations. All rights reserved.

import Combine
import Foundation

open class MediaPlayerObservation: ObservableObject {

    @Published public var nowPlayingItem: SongVersion?

    public var mediaPlayer: MediaPlayer

    public init(mediaPlayer: MediaPlayer) {
        self.mediaPlayer = mediaPlayer
    }

}
