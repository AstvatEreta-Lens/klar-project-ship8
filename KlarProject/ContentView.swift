//
//  ContentView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var sidebarVM = SidebarViewModel()
    
    var body: some View {
        NavigationSplitView {
            SidebarView(viewModel: sidebarVM)
        } detail: {
            switch sidebarVM.selectedItem?.destination {
                         case .dashboard:
                             DashboardView()
                         case .conversation:
                             ChatKlarView()
                         case .knowledge:
                             KnowledgePage()
//                         case .settings:
//                             SettingsView()
                         default:
                             Text("Select a menu from sidebar").foregroundColor(.secondary)
                         }
        }
    }
}

// MARK: - Empty Detail View
struct EmptyDetailView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sidebar.left")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("Select a menu from sidebar")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Choose an option to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

#Preview {
    ContentView()
        .frame(width: 1400, height: 982)
}
