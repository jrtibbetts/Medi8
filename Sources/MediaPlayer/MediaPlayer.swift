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
