//  Created by Jason R Tibbetts on 3/22/21.

import Combine
import Foundation

open class MediaPlayerObservation: ObservableObject {

    @Published public var nowPlayingItem: SongVersion?

    public var mediaPlayer: MediaPlayer

    public init(mediaPlayer: MediaPlayer) {
        self.mediaPlayer = mediaPlayer
    }

}
