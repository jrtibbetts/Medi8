//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData
import MediaPlayer

class MockMediaImporter: MediaImporter {

    private var delegate: MediaImporterDelegate?

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext, delegate: MediaImporterDelegate? = nil) {
        self.context = context
        self.delegate = delegate
    }

    func importMedia() throws {
        delegate?.willStartImporting()
        delegate?.didStartImporting()

        // Load the music that's in this bundle.
        if let mockDataFile = Bundle(for: type(of: self)).path(forResource: "MockData", ofType: "plist") {
            if let mockData = NSDictionary(contentsOfFile: mockDataFile) {
                mockData.enumerateKeysAndObjects { (artistName, releases, stop) in
                    if let artist = fetchOrCreateArtist(named: artistName as! String) {
                        (releases as! NSDictionary).enumerateKeysAndObjects { (releaseName, tracks, stop) in
                            add(releaseNamed: releaseName as! String, with: tracks as! NSDictionary, to: artist, in: context)
                        }
                    }
                }
            }

            try context.save()

            delegate?.willFinishImporting()
            delegate?.didFinishImporting(with: nil)
        }
    }

    func add(releaseNamed releaseTitle: String,
             with rawTracks: NSDictionary,
             to artist: Artist,
             in context: NSManagedObjectContext) {
        let release = fetchOrCreateMasterRelease(named: releaseTitle, by: [artist])!
        let tracksArray = rawTracks["Tracks"] as! NSArray

        tracksArray.enumerateObjects { (element, index, stop) in
            let dataDict = element as! NSDictionary

            release.versions?.forEach { (version) in
                if let trackListing = (version as! ReleaseVersion).trackListing {
                    add(songNamed: dataDict["Title"] as! String,
                        artist: artist,
                        to: trackListing,
                        in: context)
                }
            }
        }
    }

    func add(songNamed songTitle: String,
             artist: Artist,
             to tracks: TrackListing,
             in context: NSManagedObjectContext) {
        let _ = fetchOrCreateSong(named: songTitle, by: artist)
    }

}
