//  Copyright © 2021 Poikile Creations. All rights reserved.

#if os(macOS)

import Foundation
import iTunesLibrary
import SwiftUI

public class MediaPlayerLibrary: MediaLibrary {

    // MARK: - Properties

    private var iTunesLibrary: ITLibrary?

    // MARK: - Initialization

    public override init() {
        super.init()
        do {
            iTunesLibrary = try ITLibrary(apiVersion: "1.0")
        } catch {
            print("Failed to initialize the user's iTunes library", error)
        }

        refreshSongs()
        finishedImporting = true
    }

    // MARK: - MediaLibrary Functions

    override open func refreshSongs() {
        songs = iTunesLibrary?.allMediaItems ?? []
    }

}

extension ITLibMediaItem: Song {

    public var albumArtistName: String? {
        return self.album.albumArtist
    }

    public var albumID: UInt64 {
        return self.album.persistentID.uint64Value
    }

    public var albumTitle: String? {
        return album.title
    }

    public var albumTrackNumber: Int {
        return trackNumber
    }

    public var artistName: String? {
        return artist?.name
    }

    public var discNumber: Int {
        return album.discNumber
    }

    public var id: UInt64 {
        return persistentID.uint64Value
    }

    public var images: [Artwork]? {
        guard let artwork = artwork else {
            return nil
        }

        return [artwork]
    }

    public var lyrics: String? {
        return nil
    }

    public var playbackDuration: TimeInterval {
        return TimeInterval(Double(totalTime) / 1000.0)
    }

    public var songTitle: String {
        return title
    }

    public var sortArtistName: String {
        return artist?.sortName ?? artist?.name ?? ""
    }

}

extension ITLibArtwork: Artwork {

    public var bounds: CGRect {
        return CGRect(origin: .zero, size: CGSize(width: 300.0, height: 300.0))
    }

    public func image(size: CGSize) -> Image? {
        guard let image = image else {
            return nil
        }

        return Image(nsImage: image)
    }

}

#endif
