//
//  SidebarView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI
import Foundation

struct SidebarView: View {
    @ObservedObject var viewModel: SidebarViewModel
    var body: some View {
        List(selection: $viewModel.selectedItem)
        {
            ForEach(viewModel.items) { item in
                Label(item.title, systemImage: item.icon)
                    .tag(item)
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 180)
        .navigationTitle("Menu")
    }
   
    
}
