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
           NavigationSplitView(columnVisibility : .constant(.all)) {
               SidebarView(viewModel: sidebarVM)
                   .accessibilityLabel("Sidebar")
           } detail: {
               switch sidebarVM.selectedItem?.destination {
               case .dashboard:
                   DashboardView()
                       .ignoresSafeArea(edges : .top)
                       .fullScreenSafePadding()
               case .conversation:
                   ChatKlarView()
                       .ignoresSafeArea(edges : .top)
                       .fullScreenSafePadding()
               case .knowledge:
                   KnowledgePage()
                       .ignoresSafeArea(edges : .top)
                       .fullScreenSafePadding()
               case .settings:
                   SettingsView(editAction: {}, saveAction: {})
                       .padding()
                       .ignoresSafeArea(edges : .top)
                       .fullScreenSafePadding()
               case .contact:
                   MainContactView()
                       .padding(.top)
                       .padding(.horizontal)
                       .padding(.bottom, 10)
                       .ignoresSafeArea(edges : .top)
                       .fullScreenSafePadding()
               default:
                   Text("Select a menu from sidebar").foregroundColor(.secondary)
               }
           }           
           .environment(\.locale, Locale(identifier: "id-ID"))
           .navigationSplitViewStyle(.balanced) // hide hide sidebar
           .detectFullScreen()
           .accessibilityLabel("Klar")
       }
}

#Preview {
    ContentView()
}
