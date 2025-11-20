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
        SidebarItem(title: NSLocalizedString("Dashboard", comment : ""), icon: "house", destination: .dashboard),
        SidebarItem(title: NSLocalizedString("Conversation", comment : ""), icon: "bubble", destination: .conversation),
        SidebarItem(title: NSLocalizedString("Knowledge", comment : ""), icon: "book.closed", destination: .knowledge),
        SidebarItem(title: NSLocalizedString("Contact", comment : ""), icon : "person.2", destination: .contact)
    ]
    
    // Settings
    let bottomItems: [SidebarItem] = [
        SidebarItem(title: NSLocalizedString("Settings", comment : ""), icon: "gear", destination: .settings)
    ]
    
    // helper
    var items: [SidebarItem] {
        mainItems + bottomItems
    }
}
