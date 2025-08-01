//
//  InstructionOverlay.swift
//  InstructUI
//
//  Created by Michael Borgmann on 12/07/2025.
//

import SwiftUI

/// A translucent overlay used in tutorials to highlight a specific on-screen area
/// with a cutout and display an instructional message.
///
/// `InstructionOverlay` is typically used in combination with a tutorial controller or modifier,
/// and will block interactions behind it while allowing the user to tap to advance.
///
/// Example usage:
/// ```swift
/// InstructionOverlay(
///     message: "Tap here to start",
///     highlightFrame: CGRect(x: 100, y: 200, width: 150, height: 44),
///     isMessageBelow: true
/// )
/// ```
struct InstructionOverlay: View {
    
    // MARK: - Properties
    
    /// The instructional message shown near the highlighted element.
    let message: String
    
    /// The frame of the on-screen element to be highlighted.
    let highlightFrame: CGRect
    
    /// Controls whether the message is shown below the highlight frame (if `true`) or above it (if `false`).
    let isMessageBelow: Bool

    // MARK: - View
    
    /// The body of the instruction overlay view.
    var body: some View {
        Color.black.opacity(0.6)
            .ignoresSafeArea()
            .mask(
                HoleShape(hole: highlightFrame)
                    .fill(style: FillStyle(eoFill: true))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.yellow, lineWidth: 4)
                    .frame(width: highlightFrame.width, height: highlightFrame.height)
                    .position(x: highlightFrame.midX, y: highlightFrame.midY)
            )
            .overlay(
                Text(message)
                    .font(.title2)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .foregroundColor(.black)
                    .frame(maxWidth: 300)
                    .position(x: highlightFrame.midX, y: isMessageBelow ? highlightFrame.maxY + 60 : highlightFrame.minY - 60)
            )
            .onTapGesture {
                // progress to next step on tap
                NotificationCenter.default.post(name: .instructionAdvance, object: nil)
            }
    }
}

// MARK: - Cutout Shape

extension InstructionOverlay {
    
    /// A shape with a rectangular cutout used to highlight a specific area.
    ///
    /// Used as a mask to create a transparent hole in the overlay.
    private struct HoleShape: Shape {
        
        /// The frame of the rectangular hole to be cut out of the shape.
        let hole: CGRect
        
        /// Returns a path with a rounded rectangular cutout inside the given rect.
        ///
        /// - Parameter rect: The full drawing area for the shape.
        /// - Returns: A path with a transparent cutout defined by `hole`.
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addRect(rect)
            path.addRoundedRect(in: hole, cornerSize: CGSize(width: 16, height: 16))
            return path
        }
    }
}

// MARK: - Previewables

#Preview("InstructionOverlay (Bottom-Aligned)") {
    ZStack {
        Color.white.ignoresSafeArea()

        InstructionOverlay(
            message: "This button does something important.",
            highlightFrame: CGRect(x: 100, y: 500, width: 180, height: 60),
            isMessageBelow: true
        )
    }
    // NOTE: Optionally uncomment to preview as a fullscreen overlay:
    //.edgesIgnoringSafeArea(.all)
}

#Preview("InstructionOverlay (Top-Aligned)") {
    ZStack {
        Color.white.ignoresSafeArea()

        InstructionOverlay(
            message: "Tap here to start recording.",
            highlightFrame: CGRect(x: 100, y: 150, width: 160, height: 60),
            isMessageBelow: false
        )
    }
    // NOTE: Optionally uncomment to preview as a fullscreen overlay:
    //.edgesIgnoringSafeArea(.all)
}
