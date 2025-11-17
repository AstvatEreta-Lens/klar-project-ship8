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
                       .ignoresSafeArea(edges : .top)
               case .conversation:
                   ChatKlarView()
                       .ignoresSafeArea(edges : .top)
               case .knowledge:
                   KnowledgePage()
                       .ignoresSafeArea(edges : .top)
               case .settings:
                   SettingsView(editAction: {}, saveAction: {})
                       .padding()
                       .ignoresSafeArea(edges : .top)
               case .contact:
                   ContactTableView()
                       .padding()
//                       .ignoresSafeArea(edges : .top)
               default:
                   Text("Select a menu from sidebar").foregroundColor(.secondary)
               }
           }
       }
}

#Preview {
    ContentView()
}
