//  Created by Jason R Tibbetts on 4/12/21.

import Foundation
import MediaPlayer

#if os(iOS)
/// Inspiration: https://stackoverflow.com/questions/58435382/how-to-show-mpmediaitem-artwork-in-a-swiftui-list
public class MediaPlayerLibrary: MediaLibrary {

    public static let musicPlayer: MPMusicPlayerController = .applicationQueuePlayer

    private var dispatchQueue = DispatchQueue(label: "MediaLibrary")

    private var finishedImportingAlbums = false {
        didSet {
            updateImportStatus()
        }
    }

    private var finishedImportingArtists = false {
        didSet {
            updateImportStatus()
        }
    }

    private var finishedImportingPlaylists = false {
        didSet {
            updateImportStatus()
        }
    }

    private var finishedImportingSongs = false {
        didSet {
            updateImportStatus()
        }
    }

    private func updateImportStatus() {
        finishedImporting = finishedImportingAlbums
        && finishedImportingArtists
        && finishedImportingPlaylists
        && finishedImportingSongs
    }

    override public func refreshAlbums() {
        DispatchQueue.main.async { [weak self] in
            self?.finishedImportingAlbums = false
        }

        dispatchQueue.sync {
            let albums = MPMediaQuery.albums().collections ?? []

            DispatchQueue.main.async { [weak self] in
                self?.albums = albums
                self?.finishedImportingAlbums = true
            }
        }
    }

    override public func refreshPlaylists() {
        DispatchQueue.main.async { [weak self] in
            self?.finishedImportingPlaylists = false
        }

        dispatchQueue.sync { [weak self] in
            let playlists = MPMediaQuery.playlists().collections ?? []

            DispatchQueue.main.async { [weak self] in
                self?.playlists = playlists
                self?.finishedImportingPlaylists = true
            }
        }
    }

    override public func refreshSongs() {
        DispatchQueue.main.async { [weak self] in
            self?.finishedImportingSongs = false
            self?.finishedImportingArtists = false
        }

        dispatchQueue.sync { [unowned self] in
            let songs = MPMediaQuery.songs().items ?? []

            let artists = songs
                .compactMap { MockArtist($0.artist ?? "", sortName: $0.sortArtist) }

            let sortedArtists = Set<MockArtist>(artists)
                .sorted()

            DispatchQueue.main.async { [weak self] in
                self?.songs = songs
                self?.artists = sortedArtists
                self?.finishedImportingSongs = true
                self?.finishedImportingArtists = true
            }
        }
    }

    override public init() {
        super.init()
        authStatus = .notDetermined
        finishedImporting = false

        MPMediaLibrary.requestAuthorization { [weak self] (authStatus) in
            self?.authStatus = authStatus

            if authStatus == .authorized {
                self?.refreshAlbums()
                self?.refreshPlaylists()
                self?.refreshSongs()
            }
        }
    }

}
#endif
