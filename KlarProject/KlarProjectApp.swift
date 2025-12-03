//
//  KlarProjectApp.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

@main
struct KlarProjectApp: App {
    @StateObject private var serviceManager = ServiceManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.locale, Locale(identifier: "id-ID"))
                .accessibilityLabel("Klar App")
                .environmentObject(ConversationListViewModel.shared)
                .environmentObject(EvaluationViewModel.shared)
                .environmentObject(ServiceManager.shared)
                .background(Color.white)
                .onAppear {
                    // Force full screen on launch
                    if let window = NSApplication.shared.windows.first {
                        window.toggleFullScreen(nil)
                    }
                    
                    // Register client with backend
                    Task {
                        // Load config
                        let configManager = ConfigManager()
                        configManager.loadConfig()
                        
                        // Configure API service with server URL
                        if !configManager.config.webhookServerURL.isEmpty {
                            serviceManager.configure(baseURL: configManager.config.webhookServerURL)
                        }
                        
                        // Register client
                        await serviceManager.register()
                        
                        // Start status monitoring
                        serviceManager.startStatusMonitoring()
                    }
                }
                .onDisappear {
                    // Stop status monitoring and unregister client when app closes
                    serviceManager.stopStatusMonitoring()
                    Task {
                        await serviceManager.unregister()
                    }
                }
        }
        .defaultSize(width: 1500, height: 982)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .appTermination) {
                Button("Quit") {
                    Task {
                        await serviceManager.unregister()
                        NSApplication.shared.terminate(nil)
                    }
                }
            }
        }
   
    }
}
