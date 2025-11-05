//
//  KlarProjectApp.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

@main
struct KlarProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Force full screen on launch
                    if let window = NSApplication.shared.windows.first {
                        window.toggleFullScreen(nil)
                    }
                }
        }
    }
}
