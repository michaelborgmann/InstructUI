//
//  InstructionGuide.swift
//  InstructUI
//
//  Created by Michael Borgmann on 12/07/2025.
//

import SwiftUI
import SpeechKit

/// A view modifier that visually and audibly guides the user through a series of instructional steps.
///
/// `InstructionGuide` highlights specific regions of the UI using `InstructionOverlay` and reads aloud
/// associated messages using the provided `SpeechSynthesizer`.
///
/// Use this modifier together with `InstructionStep` and view anchors defined via `.instructionAnchor(...)`.
/// It's particularly useful in contexts where users—such as children or early readers—benefit from
/// spoken instructions and clear visual cues.
///
/// ### Example
/// ```swift
/// VStack {
///     Button("Tap me") { ... }
///         .instructionAnchor(id: "start-button")
/// }
/// .modifier(InstructionGuide(steps: $steps, currentStepIndex: $currentIndex, speaker: speaker))
/// ```
public struct InstructionGuide: ViewModifier {
    
    // MARK: - State
    
    /// The ordered list of steps to guide the user through.
    @Binding var steps: [InstructionStep]
    
    /// The index of the currently active instruction step, or `nil` if no step is active.
    @Binding var currentStepIndex: Int?
    
    // MARK: - Properties
    
    /// The speech synthesizer used to speak each instruction step aloud.
    var speaker: SpeechSynthesizer
    
    // MARK: - Lifecycle
    
    public init(
        steps: Binding<[InstructionStep]>,
        currentStepIndex: Binding<Int?>,
        speaker: SpeechSynthesizer
    ) {
        self._steps = steps
        self._currentStepIndex = currentStepIndex
        self.speaker = speaker
    }
    
    // MARK: - View
    
    /// The body of the card view.
    public func body(content: Content) -> some View {
        ZStack {
            content
                .overlayPreferenceValue(ViewFrameKey.self) { frameDict in
                    if let index = currentStepIndex,
                       let step = steps[safe: index]
                    {
                        InstructionOverlay(
                            message: step.message,
                            highlightFrame: step.highlightFrame,
                            isMessageBelow: step.isMessageBelow
                        )
                        .onAppear {
                            speakCurrentMessage()
                        }
                        
                    }
                }
                .onChange(of: currentStepIndex) { oldIndex, newIndex in
                    speakCurrentMessage()
                }

            if currentStepIndex != nil {
                skipButton
            }
        }
    }
    
    // MARK: - Helper
    
    /// Speaks the message associated with the currently active instruction step using the provided `SpeechSynthesizer`.
    private func speakCurrentMessage() {
        if let step = steps[safe: currentStepIndex ?? -1] {
            speaker.speak(text: step.message)
        }
    }
    
    /// A skip button allowing the user to exit the instruction sequence early.
    private var skipButton: some View {
        VStack {
            HStack {
                Spacer()
                Button("Skip") {
                    currentStepIndex = nil
                }
                .padding()
                .foregroundColor(.white)
            }
            Spacer()
        }
    }
}

// MARK: - SwiftUI Previews

// A preview demonstrating how `InstructionGuide` overlays a single button.
#Preview("Single-Step Instruction") {
    
    @Previewable @State var instructionSteps: [InstructionStep] = []
    @Previewable @State var instructionIndex: Int? = 0
    @Previewable @State var speaker = SpeechSynthesizer()
    
    VStack {
        Button(action: { instructionIndex = 0 }) {
            Text("✅ Button")
        }
        .buttonStyle(.bordered)
        .instructionAnchor(id: "instruction-button")
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .modifier(InstructionGuide(steps: $instructionSteps, currentStepIndex: $instructionIndex, speaker: speaker))
    .onPreferenceChange(ViewFrameKey.self) { frames in
        if !frames.isEmpty {
            instructionSteps = [
                InstructionStep(message: "This is an instruction overlay on top of a button", highlightFrame: frames["instruction-button"]!, isMessageBelow: true)
            ]
        }
    }
    .onReceive(NotificationCenter.default.publisher(for: .instructionAdvance)) { _ in
        if let i = instructionIndex {
            let next = i + 1
            instructionIndex = next < instructionSteps.count ? next : nil
        }
    }
    .edgesIgnoringSafeArea(.all)
}

// A preview showing how `InstructionGuide` behaves in a scrollable context using `ScrollViewReader`.

#Preview("Scrollable Instruction") {
    
    @Previewable @State var instructionSteps: [InstructionStep] = []
    @Previewable @State var instructionIndex: Int? = 0
    @Previewable @State var speaker = SpeechSynthesizer()
    
    ScrollViewReader { proxy in
        ScrollView {
            ForEach(0..<10) { i in
                
                if i == 7 {
                    Button(action: { instructionIndex = 0 }) {
                        Text("Show Instruction")
                    }
                    .buttonStyle(.bordered)
                    .instructionAnchor(id: "instruction-button")
                    .id("instruction-button")
                    .padding()
                } else {
                    Text("Item \(i)")
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.4))
                        .cornerRadius(8)
                }
            }
        }
        .onAppear() {
            if let step = instructionSteps.first {
                withAnimation {
                    proxy.scrollTo(step.scrollTargetId, anchor: .center)
                }
            }
        }
        .onChange(of: instructionIndex) { _, newIndex in
            if let newIndex = newIndex, let step = instructionSteps[safe: newIndex] {
                withAnimation {
                    proxy.scrollTo(step.scrollTargetId, anchor: .center) // 👈 center it
                }
            }
        }
    }
    .modifier(InstructionGuide(steps: $instructionSteps, currentStepIndex: $instructionIndex, speaker: speaker))
    .onPreferenceChange(ViewFrameKey.self) { frames in
        if !frames.isEmpty {
            instructionSteps = [
                InstructionStep(message: "This is an instruction overlay on top of a ScrollView", highlightFrame: frames["instruction-button"]!, isMessageBelow: true, scrollTargetId: "instruction-button")
            ]
        }
    }
    .onReceive(NotificationCenter.default.publisher(for: .instructionAdvance)) { _ in
        if let i = instructionIndex {
            let next = i + 1
            instructionIndex = next < instructionSteps.count ? next : nil
        }
    }
    .edgesIgnoringSafeArea(.all)
}
