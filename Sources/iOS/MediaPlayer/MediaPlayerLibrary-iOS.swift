//  Copyright © 2021 Poikile Creations. All rights reserved.

import CoreData
import Foundation
import MediaPlayer

#if os(iOS)

/// Inspiration: https://stackoverflow.com/questions/58435382/how-to-show-mpmediaitem-artwork-in-a-swiftui-list
public class MediaPlayerLibrary: MediaLibrary {

    public static let musicPlayer: MPMusicPlayerController = .applicationQueuePlayer

    private var dispatchQueue = DispatchQueue(label: "MediaLibrary")

    private var importer: MediaPlayerImporter

    public init() {
        let context = Medi8PersistentContainer.sharedInMemoryContext
        importer = MediaPlayerImporter(context)
        super.init(context: context)

        authStatus = .notDetermined
        finishedImporting = false
    }

}

#endif
