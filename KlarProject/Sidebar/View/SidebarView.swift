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
    @Binding var selectedItem: SidebarItem?
    
    var body: some View {
        VStack {
            logoMenu()
            listSidebarItem()
        }
        .frame(minWidth: 180)
    }
}



extension SidebarView {
    
    func listSidebarItem() -> some View {
        List(selection: $selectedItem) {
                    ForEach(viewModel.items) { item in
                        NavigationLink(value: item) {
                            Label(item.title, systemImage: item.icon)
                        }
                        .tag(item)
                    }
                }
        
        }
    
    func logoMenu() -> some View {
        VStack {
                Image("default_Klar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .padding(8)
                
            }
    }
}
