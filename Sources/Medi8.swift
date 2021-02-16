//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import Foundation

/// An empty class that can be used to get the Medi8 bundle.
public class Medi8: NSObject {

    public static var resourceBundle: Bundle = {
        let bundleName = "Medi8_Medi8.bundle"

        let locationCandidates = [Bundle.main.resourceURL,
                                  Bundle(for: Medi8.self).resourceURL,
                                  Bundle.main.bundleURL]

        for path in locationCandidates {
            if let bundleUrl = path?.appendingPathComponent(bundleName),
               let bundle = Bundle(url: bundleUrl) {
                return bundle
            }
        }

        fatalError("Failed to load the resource bundle from \(locationCandidates)")
    }()

    public static var modelContainer: NSPersistentContainer = {
        guard let modelUrl = Medi8.resourceBundle.url(forResource: "Medi8", withExtension: "momd"),
           let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("The model couldn't be loaded from the Medi8 file.")
        }

        var container = NSPersistentContainer(name: "Medi8", managedObjectModel: model)
        container.loadPersistentStores { (description, error) in
            print("Loaded \(description): \(error?.localizedDescription)")
        }

        return container
    }()

}
