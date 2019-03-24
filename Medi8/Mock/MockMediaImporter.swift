//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData
import MediaPlayer
import Stylobate

class MockMediaImporter: MediaImporter {

    private weak var delegate: MediaImporterDelegate?

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext, delegate: MediaImporterDelegate? = nil) {
        self.context = context
        self.delegate = delegate
    }

    func importMedia() throws {
        delegate?.willStartImporting()
        delegate?.didStartImporting()

        // Load the music that's in this bundle.
        let mockData: MockData = try JSONUtils.jsonObject(forFileNamed: "MockData",
                                                          ofType: "json",
                                                          inBundle: Bundle(for: type(of: self)))
        try mockData.releases.forEach { (release) in
            if let artist = fetchOrCreateArtist(named: mockData.artist) {
                add(releaseNamed: release.title, with: release.tracks, to: artist, in: context)
            }

            try context.save()

            delegate?.willFinishImporting()
            delegate?.didFinishImporting(with: nil)
        }
    }

    func add(releaseNamed releaseTitle: String,
             with tracks: [MockData.Track],
             to artist: Artist,
             in context: NSManagedObjectContext) {
        let release = fetchOrCreateMasterRelease(named: releaseTitle, by: [artist])!
        tracks.forEach { (track) in
            release.versions?.forEach { (version) in
                if let trackListing = (version as? ReleaseVersion)?.trackListing {
                    add(songNamed: track.title,
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
        _ = fetchOrCreateSong(named: songTitle, by: artist)
    }

}
