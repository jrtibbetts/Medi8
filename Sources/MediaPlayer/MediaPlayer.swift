//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)

import MediaPlayer

public typealias PlaybackState = MPMusicPlaybackState

#elseif os(macOS)

// MARK: - macOS Media Player

public enum PlaybackState: Int {
    case paused
    case playing
    case stopped
}

#endif

/// Implemented by classes that can load, play, pause, and skip media items. On
/// iOS, this is implemented by the `MPMusicPlayerController`; on macOS, I'm
/// not sure whether there's a built-in player to use.
public protocol MediaPlayer {

    // MARK: - MPMusicPlayerController PropertiesMPMusicPlayerController

    var currentPlaybackTime: TimeInterval { get set }

    var nowPlayingSong: MPMediaItem? { get }

    var playbackState: PlaybackState { get }

    // MARK: - MPMusicPlayerController Functions

    func pause()

    func play()

    func prepareToPlay()

    func setQueue(with: [MPMediaItem])

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
