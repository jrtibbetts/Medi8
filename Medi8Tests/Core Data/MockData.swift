//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

public struct MockData: Codable {

    public var artist: String
    public var releases: [Release]

    public struct Release: Codable {

        public var title: String
        public var tracks: [Track]

    }

    public struct Track: Codable {

        public var title: String
        public var duration: String
        public var comment: String
        public var year: Int
        public var composer: String

    }

}
