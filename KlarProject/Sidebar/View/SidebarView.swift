//
//  SidebarView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

struct SidebarRow: View {
    let item: SidebarItem
    let isSelected: Bool
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isSelected ? item.icon + ".fill" : item.icon)
                .foregroundColor(Color.primaryText)
                .frame(width: 20)

            Text(item.title)
                .font(.body)
                .foregroundColor(Color.primaryText)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .padding(.leading, 25)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 3)
                .fill(
                    isSelected ? Color.tertiaryText :
                    (isHovered ? Color.tertiaryText.opacity(0.3) : Color.clear)
                )
        )
        .overlay(alignment: .leading) {
            if isHovered || isSelected {
                UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 3,
                    topTrailingRadius: 3
                )
                .foregroundColor(Color.secondaryText)
                .frame(width: 4)
                .padding(.vertical, 3)
                .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isHovered || isSelected)

        
        .onHover { hover in
            isHovered = hover
        }
        .animation(.easeInOut(duration: 0.15), value: isHovered)
    }
}

// MARK: - Sidebar View
struct SidebarView: View {
    @ObservedObject var viewModel: SidebarViewModel
    @State private var isHovering: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Image("Frame 60")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 214, height: 33)
                    .padding(.top, 20)
                    .padding(.bottom, 47)
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundPrimary)

            VStack(spacing: 4) {
                ForEach(viewModel.mainItems) { item in
                    Button(action: {
                        viewModel.selectedItem = item
                    }) {
                        SidebarRow(item: item, isSelected: viewModel.selectedItem == item)
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()

            VStack(spacing: 4) {
                ForEach(viewModel.bottomItems) { item in
                    Button(action: {
                        viewModel.selectedItem = item
                    }) {
                        SidebarRow(item: item, isSelected: viewModel.selectedItem == item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.bottom, 16)
        }

        .frame(minWidth: 214, maxWidth: 247)
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    SidebarView(viewModel: SidebarViewModel())
        .frame(width: 250, height: 400)
}
