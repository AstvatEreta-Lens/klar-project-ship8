
//
//  FullScreenDetector.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 19/11/25.
//

import SwiftUI
import AppKit

// Environment key to track full screen state
struct FullScreenKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isFullScreen: Bool {
        get { self[FullScreenKey.self] }
        set { self[FullScreenKey.self] = newValue }
    }
}

// ViewModifier to detect and inject full screen state
struct FullScreenDetectorModifier: ViewModifier {
    @State private var isFullScreen = false

    func body(content: Content) -> some View {
        content
            .environment(\.isFullScreen, isFullScreen)
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.didEnterFullScreenNotification)) { _ in
                isFullScreen = true
            }
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.didExitFullScreenNotification)) { _ in
                isFullScreen = false
            }
            .onAppear {
                // Check initial state
                if let window = NSApplication.shared.windows.first {
                    isFullScreen = window.styleMask.contains(.fullScreen)
                }
            }
    }
}

extension View {
    func detectFullScreen() -> some View {
        modifier(FullScreenDetectorModifier())
    }

    // Apply padding.top when in full screen to prevent content from being cut off by title bar
    func fullScreenSafePadding() -> some View {
        modifier(FullScreenSafePaddingModifier())
    }
}

// ViewModifier to apply padding when in full screen
struct FullScreenSafePaddingModifier: ViewModifier {
    @Environment(\.isFullScreen) var isFullScreen

    func body(content: Content) -> some View {
        content
            .padding(.top, isFullScreen ? 1 : 0)
    }
}
