//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation
import MediaPlayer
import SwiftUI

public protocol Artwork {

    var bounds: CGRect { get }

    func image(size: CGSize) -> Image?

}

public struct MockArtwork: Artwork {

    public var bounds: CGRect = .init(origin: .zero, size: .init(width: 300.0, height: 300.0))

    public func image(size: CGSize) -> Image? {
        return nil
    }

}

extension MPMediaItemArtwork: Artwork {

    public func image(size: CGSize) -> Image? {
        guard let image = image(at: size) else {
            return nil
        }

        #if os(macOS)
        return Image(nsImage: image)
        #else
        return Image(uiImage: image)
        #endif
    }

}
