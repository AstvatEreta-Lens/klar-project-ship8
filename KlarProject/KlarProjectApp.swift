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
                .environment(\.locale, Locale(identifier: "id"))
                .accessibilityLabel("Klar App")
                .background(Color.white)
        }
        .defaultSize(width: 1500, height: 982)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
