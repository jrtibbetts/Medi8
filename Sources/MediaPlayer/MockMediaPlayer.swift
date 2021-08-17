//  Created by Jason R Tibbetts on 8/17/21.

import Foundation
import MediaPlayer

open class MockMediaPlayer: ObservableObject, MediaPlayer {

    public var isPreparedToPlay: Bool {
        return playbackState != .stopped
    }

    public var isPlaying: Bool  {
        return playbackState == .playing
    }

    @Published public var playbackState: PlaybackState = .stopped

    public var currentPlaybackTime: TimeInterval = 300

    public var currentPlaybackRate: Float = 0.0

    public var nowPlayingSong: MPMediaItem? = nil

    public init() {

    }

    open func prepareToPlay() {

    }

    open func setQueue(with songs: [MPMediaItem]) {

    }

    open func play() {
        playbackState = .playing
    }

    open func pause() {
        playbackState = .paused
    }

    open func stop() {
        playbackState = .stopped
    }

    open func beginSeekingForward() {
        // nothing
    }

    open func beginSeekingBackward() {
        // nothing
    }

    open func endSeeking() {
        // nothing
    }

    // MediaPlayer

    open func skipToBeginning() {

    }

    open func skipToNextItem() {

    }

    open func skipToPreviousItem() {

    }

}
