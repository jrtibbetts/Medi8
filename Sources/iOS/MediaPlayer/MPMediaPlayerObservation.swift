//  Copyright © 2021 Poikile Creations. All rights reserved.

import Combine
import Foundation
import MediaPlayer
import SwiftUI

#if os(iOS)

/// An observable `MediaPlayerObservation` that publishes every time the
/// media player's playback state changes. (Its superclass also publishes the
/// item that's currently playing.)
public class MPMediaPlayerObservation: MediaPlayerObservation {

    @Published public var playbackState: MPMusicPlaybackState = .stopped

    @Published public var repeatMode: MPMusicRepeatMode = .default

    @Published public var shuffleState: MPMusicShuffleMode = .default

    var context = Medi8PersistentContainer.sharedInMemoryContext

    var notifier: NotificationCenter = .default

    var nowPlayingItemObserver: NSObjectProtocol? {
        didSet {
            if let oldValue = oldValue {
                notifier.removeObserver(oldValue)
            }
        }
    }

    var playbackStateObserver: NSObjectProtocol? {
        didSet {
            if let oldValue = oldValue {
                notifier.removeObserver(oldValue)
            }
        }
    }

    var musicPlayer: MPMusicPlayerController {
        return mediaPlayer as! MPMusicPlayerController
    }

    public init(mediaPlayer: MPMusicPlayerController) {
        super.init(mediaPlayer: mediaPlayer)

        self.musicPlayer.beginGeneratingPlaybackNotifications()
        playbackStateObserver = notifier.addObserver(forName: .MPMusicPlayerControllerPlaybackStateDidChange,
                                                     object: self.musicPlayer,
                                                     queue: nil) { [weak self] (notification) in
            if let mediaPlayer = self?.musicPlayer {
                self?.playbackState = mediaPlayer.playbackState
            }
        }

        nowPlayingItemObserver = notifier.addObserver(forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                                      object: self.musicPlayer, queue: nil) { [weak self] (notification) in
            if let strongSelf = self {
                strongSelf.nowPlayingItem = strongSelf.musicPlayer.nowPlayingItem?.song(strongSelf.context)
            }
        }
    }

    deinit {
        nowPlayingItemObserver = nil
        playbackStateObserver = nil
        musicPlayer.endGeneratingPlaybackNotifications()
    }

}

#endif
