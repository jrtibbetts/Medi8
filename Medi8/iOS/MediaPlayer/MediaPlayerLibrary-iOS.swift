//  Created by Jason R Tibbetts on 4/12/21.

import CoreData
import Foundation
import MediaPlayer

#if os(iOS)

/// Inspiration: https://stackoverflow.com/questions/58435382/how-to-show-mpmediaitem-artwork-in-a-swiftui-list
public class MediaPlayerLibrary: MediaLibrary {

    var context: NSManagedObjectContext = Medi8PersistentContainer.sharedInMemoryContext

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

    override public init() {
        super.init()
        authStatus = .notDetermined
        finishedImporting = false
        let importer = MediaPlayerImporter(context)
    }
}

#endif
