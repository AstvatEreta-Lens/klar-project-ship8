//
//  SidebarItem.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import Foundation
import SwiftUI

struct SidebarItem: Identifiable, Hashable {
    
    let id = UUID()
    let title: String
    let icon: String
    let destination: SidebarDestination
    
}

enum SidebarDestination {
    case dashboard
    case conversation
    case knowledge
    case settings
    case ticketing
}
