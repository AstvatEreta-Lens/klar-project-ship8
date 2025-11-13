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
               case .settings:
                   SettingsView(editAction: {}, saveAction: {})
                       .padding()
               default:
                   Text("Select a menu from sidebar").foregroundColor(.secondary)
               }
           }
       }
}

#Preview {
    ContentView()
}
