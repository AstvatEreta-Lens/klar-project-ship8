//
//  ContentView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var sidebarVM = SidebarViewModel()
    @State private var selectedItem: SidebarItem?
    
    var body: some View {
        
        NavigationSplitView {
            SidebarView(viewModel: sidebarVM, selectedItem: $selectedItem)
        } detail: {
            switch sidebarVM.selectedItem?.destination {
            case .dashboard:
                DashboardView()
            case .chat:
                ConversationView()
            case .ticketing:
                TicketingView()
            case .settings:
                SettingsView()
            default:
                Text("Select a menu from sidebar").foregroundColor(.secondary)
            }
            
        }
        .onChange(of: selectedItem) { oldvalue, newValue in
                sidebarVM.selectItem(newValue)
            }
        
    }
}


#Preview {
    ContentView()
}
