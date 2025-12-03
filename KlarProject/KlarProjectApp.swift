//
//  KlarProjectApp.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

@main
struct KlarProjectApp: App {
    @StateObject private var languageManager = LanguageManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, languageManager.locale)
                .environmentObject(languageManager)
                .accessibilityLabel("Klar App")
                .background(Color.backgroundPrimary.opacity(0.5))
                .id(languageManager.locale.identifier) // Force view refresh on language change
        }
        .defaultSize(width: 1500, height: 982)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
