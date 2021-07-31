//  Created by Jason R Tibbetts on 4/15/21.

import Foundation
import MediaPlayer

/// Implemented by classes that can load, play, pause, and skip media items. On
/// iOS, this is implemented by the `MPMusicPlayerController`; on macOS, I'm
/// not sure whether there's a built-in player to use.
public protocol MediaPlayer {

    // MARK: - MPMusicPlayerController PropertiesMPMusicPlayerController

    var currentPlaybackTime: TimeInterval { get set }

    var nowPlayingSong: Song? { get }

    var playbackState: PlaybackState { get }

    // MARK: - MPMusicPlayerController Functions

    func pause()

    func play()

    func prepareToPlay()

    func setQueue(with: [Song])

    func skipToBeginning()

    func skipToNextItem()

    func skipToPreviousItem()

}

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

    public var nowPlayingSong: Song? = nil

    public func prepareToPlay() {

    }

    public func setQueue(with songs: [Song]) {

    }

    public func play() {
        playbackState = .playing
    }

    public func pause() {
        playbackState = .paused
    }

    public func stop() {
        playbackState = .stopped
    }

    public func beginSeekingForward() {
        // nothing
    }

    public func beginSeekingBackward() {
        // nothing
    }

    public func endSeeking() {
        // nothing
    }

    // MediaPlayer

    public func skipToBeginning() {

    }

    public func skipToNextItem() {

    }

    public func skipToPreviousItem() {

    }

}
