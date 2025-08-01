//
//  ViewFrameKey.swift
//  InstructUI
//
//  Created by Michael Borgmann on 12/07/2025.
//

import SwiftUI

/// A preference key used to collect view frames by identifier.
///
/// This allows views to report their global frame (e.g. for instruction overlays),
/// which can later be retrieved using `.onPreferenceChange`.
public struct ViewFrameKey: PreferenceKey {
    
    /// The default value is an empty dictionary.
    public static var defaultValue: [String: CGRect] { [:] }

    /// Combines multiple reported frames into a single dictionary.
    ///
    /// If multiple values are reported for the same key, the last one wins.
    public static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        for (key, rect) in nextValue() {
            #if DEBUG
            if value.keys.contains(key) {
                print("⚠️ ViewFrameKey: Duplicate key \"\(key)\" detected. Overwriting previous frame.")
            }
            #endif
            value[key] = rect
        }
    }
}
