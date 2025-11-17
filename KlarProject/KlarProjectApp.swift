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
                .frame(minHeight : 982, maxHeight : .infinity)
                .frame(minWidth : 1500, maxWidth: .infinity)
                .background(Color.white)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
