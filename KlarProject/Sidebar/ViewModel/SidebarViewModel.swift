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
    
    let items: [SidebarItem] = [
        SidebarItem(title: "Dashboard", icon: "rectangle.grid.2x2", destination: .dashboard),
        SidebarItem(title: "Conversations", icon: "bubble", destination: .chat),
        SidebarItem(title: "Knowledge", icon: "text.book.closed.fill", destination: .ticketing),
        SidebarItem(title: "Contact", icon: "person.2.fill", destination: .settings),
        SidebarItem(title: "Analytics", icon: "chart.bar", destination: .settings)
    ]
    
    func selectItem(_ item: SidebarItem?) {
           selectedItem = item
       }
}
