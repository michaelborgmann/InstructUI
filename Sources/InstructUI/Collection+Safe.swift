//
//  Collection+Safe.swift
//  InstructUI
//
//  Created by Michael Borgmann on 01/08/2025.
//

import Foundation

extension Collection {
    /// Safely accesses the element at the given index, returning `nil` if out of bounds.
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the given index, or `nil` if the index is invalid.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
