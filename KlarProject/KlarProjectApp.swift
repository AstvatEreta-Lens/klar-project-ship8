//
//  KlarProjectApp.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

@main
struct KlarProjectApp: App {
    @StateObject private var configManager = ConfigManager()
        
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .frame(minWidth: 1000, minHeight: 700)
                    .onAppear {
                        if let window = NSApplication.shared.windows.first {
                            window.toggleFullScreen(nil)
                        }
                        configManager.loadConfig()
                    }
            }
            .windowStyle(.titleBar)
            .windowResizability(.contentSize)
            .commands {
                CommandGroup(replacing: .newItem) { }
            }
        }
}
