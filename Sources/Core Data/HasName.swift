//
//  File.swift
//  File
//
//  Created by Jason R Tibbetts on 8/5/21.
//

import Foundation

public protocol HasName {

    var name: String? { get }

    var sortName: String? { get }

}

public extension HasName {
    
    var displayableName: String {
        return name ?? "Unnamed Artist"
    }
    
}
