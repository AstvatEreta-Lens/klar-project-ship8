//
//  SidebarViewModel.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import Foundation
import SwiftUI

final class SidebarViewModel: ObservableObject {
    @Published var selectedItem: SidebarItem?
    
    // Top three items
    let mainItems: [SidebarItem] = [
        SidebarItem(title: "Dashboard", icon: "house.fill", destination: .dashboard),
        SidebarItem(title: "Conversation", icon: "bubble.fill", destination: .conversation),
        SidebarItem(title: "Knowledge", icon: "book.closed", destination: .knowledge)
    ]
    
    // Settings
    let bottomItems: [SidebarItem] = [
        SidebarItem(title: "Settings", icon: "gear", destination: .settings)
    ]
    
    // helper
    var items: [SidebarItem] {
        mainItems + bottomItems
    }
}
