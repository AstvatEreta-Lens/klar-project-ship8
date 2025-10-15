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
        SidebarItem(title: "Chat", icon: "bubble", destination: .chat),
        SidebarItem(title: "Ticketing", icon: "ticket", destination: .ticketing),
        SidebarItem(title: "Settings", icon: "gearshape", destination: .settings)
    ]
}
