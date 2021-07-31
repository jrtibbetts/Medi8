//  Created by Jason R Tibbetts on 3/22/21.

import Combine
import Foundation

public class MediaPlayerObservation: ObservableObject {

    @Published public var nowPlayingItem: Song?

    public var mediaPlayer: MediaPlayer

    public init(mediaPlayer: MediaPlayer) {
        self.mediaPlayer = mediaPlayer
    }

}
