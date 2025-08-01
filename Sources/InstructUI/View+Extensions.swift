//
//  View+Extensions.swift
//  InstructUI
//
//  Created by Michael Borgmann on 12/07/2025.
//

import SwiftUI

extension View {
    public func instructionAnchor(id: String) -> some View {
        self.background(
            GeometryReader { proxy in
                Color.clear.preference(
                    key: ViewFrameKey.self,
                    value: [id: proxy.frame(in:.global)]
                )
            }
        )
    }
}
