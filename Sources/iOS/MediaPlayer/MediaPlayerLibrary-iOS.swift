//  Copyright © 2021 Poikile Creations. All rights reserved.

import CoreData
import Foundation
import MediaPlayer

#if os(iOS)

/// Inspiration: https://stackoverflow.com/questions/58435382/how-to-show-mpmediaitem-artwork-in-a-swiftui-list
public class MediaPlayerLibrary: MediaLibrary {

    public static let musicPlayer: MPMusicPlayerController = .applicationQueuePlayer

    private var dispatchQueue = DispatchQueue(label: "MediaLibrary")

    public init() {
        super.init(context: Medi8PersistentContainer.sharedInMemoryContext)
        authStatus = .notDetermined
        finishedImporting = false
        let importer = MediaPlayerImporter(context)
    }

}

#endif
