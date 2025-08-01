//
//  InstructionStep.swift
//  InstructUI
//
//  Created by Michael Borgmann on 12/07/2025.
//

import Foundation

/// A single step in a instruction sequence.
public struct InstructionStep: Identifiable {
    
    /// A unique identifier for the step.
    public let id: UUID
    
    /// The instructional message shown to the user.
    public let message: String
    
    /// The frame on screen to highlight.
    public let highlightFrame: CGRect
    
    /// Whether the message should be shown below (`true`) or above (`false`) the highlight.
    public let isMessageBelow: Bool
    
    /// An optional scroll view anchor ID for auto-scrolling.
    public var scrollTargetId: String?
    
    /// Creates a new instruction step.
    public init(id: UUID = UUID(), message: String, highlightFrame: CGRect, isMessageBelow: Bool = true, scrollTargetId: String? = nil) {
        self.id = id
        self.message = message
        self.highlightFrame = highlightFrame
        self.isMessageBelow = isMessageBelow
        self.scrollTargetId = scrollTargetId
    }
}
