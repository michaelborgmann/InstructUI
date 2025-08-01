# InstructUI

![Swift](https://img.shields.io/badge/Swift-5.9%20%7C%206.0-orange.svg?logo=swift)
![iOS](https://img.shields.io/badge/iOS-17%2B-blue.svg?logo=apple)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen?logo=swift)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
![Version](https://img.shields.io/github/v/tag/michaelborgmann/InstructUI?label=release)

🧭 A Swift package for building guided, touch-friendly instructional overlays in SwiftUI.
Ideal for apps with voice assistance, learning flows, or gesture-based tutorials.

---

## Features

- ✅ `InstructionOverlay` — draws a cutout and message above any UI element
- ✅ `InstructionGuide` — attachable `ViewModifier` for multi-step instruction flows
- ✅ Built-in speech synthesis with [SpeechKit](https://github.com/michaelborgmann/SpeechKit)
- ✅ Child-friendly and gesture-driven by design
- ✅ Works with `PreferenceKey-based layout tracking
- ✅ Fully documented with DocC-style comments

---

## Installation

Use **Swift Package Manager**:

```swift
.package(url: "https://github.com/michaelborgmann/InstructUI.git", from: "0.1.0")
```

Then import it where needed:

```swift
import InstructUI
```

If using voice support, also include:

```swift
import SpeechKit
```

---

## Usage

### 1. Define Instruction Steps

Create an array of `InstructionStep` using frames from `instructionAnchor` preferences:

```swift
@State var steps: [InstructionStep] = []
@State var currentStepIndex: Int? = 0
let speaker = SpeechSynthesizer()
```
### 2. Mark Views with Anchors

Attach `instructionAnchor(id:)` to any view you want to highlight:


```swift
Button("Tap me") {
    currentStepIndex = 0
}
.instructionAnchor(id: "start-button")
```

### 3. Add InstructionGuide Modifier

Apply the `InstructionGuide` view modifier to your main container:

```swift
.frame(maxWidth: .infinity, maxHeight: .infinity) // Optional: ensure layout fills the screen
.modifier(InstructionGuide(steps: $steps, currentStepIndex: $currentStepIndex, speaker: speaker))
.edgesIgnoringSafeArea(.all) // Optional: extend behind safe areas
```

### 4. Track Anchored View Frames

Use `.onPreferenceChange(ViewFrameKey.self)` to populate your steps once layout is complete:

```swift
.onPreferenceChange(ViewFrameKey.self) { frames in
    if !frames.isEmpty {
        instructionSteps = [
            InstructionStep(message: "This is an instruction overlay on top of a button", highlightFrame: frames["instruction-button"]!, isMessageBelow: true)
        ]
    }
}
```

### Navigate Steps (Optional)

You can advance to the next step manually or by listening to a custom event:

```swift
.onReceive(NotificationCenter.default.publisher(for: .instructionNext)) { _ in
    if let i = currentStepIndex {
        let next = i + 1
        currentStepIndex = next < steps.count ? next : nil
    }
}
```

---

## 🧪 SwiftUI Previews

To see it in action, check out the `#Preview` examples inside `InstructionGuide.swift`. These show single-step and scrollable usage patterns, helpful for getting started or customizing your implementation.

---

## Requirements

iOS 17+
Swift 5.9 or 6
Swift Concurrency
Swift Package Manager (SPM)

---

## License

MIT License — see LICENSE

Please credit this project if you use it in commercial or open-source apps.

---

## About

Created by [Michael Borgmann](https://github.com/michaelborgmann) for the Wonder Tales storytelling engine.
Part of the [Vicentina Studios](https://github.com/VicentinaStudios) toolchain for creative, language-rich experiences.
