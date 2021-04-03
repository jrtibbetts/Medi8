//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData
import MediaPlayer
import Medi8
import Stylobate

class MockMedi8Importer: Medi8Importer {

    init(context: NSManagedObjectContext, delegate: MediaImporterDelegate? = nil) {
        super.init(context)
        self.delegate = delegate
    }

    func importMedia() throws {
        delegate?.willStartImporting()
        delegate?.didStartImporting()

        // Load the music that's in this bundle.
        let mockData: MockData = try JSONUtils.jsonObject(forFileNamed: "MockData",
                                                          ofType: "json",
                                                          inBundle: Medi8Tests.resourceBundle)
        try mockData.releases.forEach { (release) in
            if let artist = try fetchOrCreateArtist(named: mockData.artist) {
                try add(releaseNamed: release.title, with: release.tracks, to: artist)
            }
        }

        try context.save()

        delegate?.willFinishImporting()
        delegate?.didFinishImporting(with: nil)
    }

    func add(releaseNamed releaseTitle: String,
             with tracks: [MockData.Track],
             to artist: Artist) throws {
        let release = try fetchOrCreateMasterRelease(named: releaseTitle, by: [artist])!
        try tracks.forEach { (track) in
            try release.versions?.forEach { _ in
                try add(songNamed: track.title, artist: artist)
            }
        }
    }

    func add(songNamed songTitle: String,
             artist: Artist) throws {
        _ = try fetchOrCreateSong(named: songTitle, by: artist)
    }

}
