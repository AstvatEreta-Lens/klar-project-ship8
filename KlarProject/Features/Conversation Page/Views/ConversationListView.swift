//
//  ConversationListView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 05/11/25.
//

import SwiftUI

struct ConversationListView: View {
    @ObservedObject var viewModel: ConversationListViewModel
    @StateObject private var filterViewModel = FilterViewModel()
    @State private var showingFilter = false
    @Environment(\.dismiss) var dismiss
    
    
    // Computed property untuk apply filter dari FilterViewModel
    var filteredHumanConversations: [Conversation] {
        filterViewModel.applyFilters(to: viewModel.filterHumanConvo)
    }
    
    var filteredAiConversations: [Conversation] {
        filterViewModel.applyFilters(to: viewModel.filterAiConvo)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main Content
                VStack(spacing: 0) {
                    headerSection
                    
                    VStack(spacing: 12) {
                        // Human Agents Section
                        ConversationSection(
                            title: NSLocalizedString("HANDLED BY HUMAN AGENTS", comment : ""),
                            count: viewModel.unreadCount,
                            viewModel: viewModel
                        ){
                            humanConversationsScrollView(height: geometry.size.height)
                        }
                        
                        // AI Section
                        ConversationSection(
                            title: NSLocalizedString("HANDLED BY AI", comment: ""),
                            count: viewModel.unresolvedCount,
                            viewModel: viewModel
                        ){
                            aiConversationsScrollView(height: geometry.size.height)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.backgroundPrimary)
                
                // Filter Overlay
                if showingFilter {
                    // Dimmed Background
                    Color.clear
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showingFilter = false
                            }
                        }
                        .allowsHitTesting(false)
                    
                    // Filter Panel
                    VStack {
                        HStack {
                            Spacer()
                            
                            FilterView(
                                viewModel: filterViewModel,
                                onApplyFilter: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showingFilter = false
                                    }
                                }
                            )
                            .frame(width: 320)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(
                                    cornerRadius: 12
                                )
                                .stroke(Color.sectionHeader, lineWidth: 1)
                            )
                            .transition(.move(edge: .trailing))
                        }
                        Spacer()
                    }
                    .padding(.top, 90) // Adjust sesuai posisi button filter
                    .padding(.trailing, 15)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Conversation")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal, 14)
                .foregroundColor(Color.primaryText)
            
            HStack {
                SearchBar(
                    text: $viewModel.searchText,
                    
                    onSearch: {
                        viewModel.searchConversations()
                    }
                )
                
                // Filter Button - Updated with toggle action
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingFilter.toggle()
                    }
                }) {
                    ZStack {
                        Image(systemName: "slider.horizontal.3")
                            .font(.body)
                            .foregroundColor(Color.primaryText)
                        
                        // Badge untuk show jumlah active filters
                        if filterViewModel.hasActiveFilters {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 10, y: -10)
                        }
                    }
                    .padding(.trailing, 25)
                    .padding(.leading, 15)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 14)
            
            // Filter Buttons
            HStack(spacing: 7) {
                FilterButton(title: NSLocalizedString("All", comment: ""), isSelected: viewModel.selectedFilter == "All") {
                    viewModel.applyFilter("All")
                }
                
                FilterButton(
                    title: NSLocalizedString("Unread", comment : ""),
//                    count: viewModel.unreadCount,
                    isSelected: viewModel.selectedFilter == "Unread"
                ) {
                    viewModel.applyFilter("Unread")
                }
                
                FilterButton(
                    title: String(localized : "Unresolved", comment: ""),
//                    count: viewModel.unresolvedCount,
                    isSelected: viewModel.selectedFilter == "Unresolved"
                ) {
                    viewModel.applyFilter("Unresolved")
                }
            }
            .padding(.horizontal, 14)
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(Color.backgroundPrimary)
    }
    
    private func humanConversationsScrollView(height: CGFloat) -> some View {
        let scrollHeight = max(200, (height - 300) / 2)
        
        return ScrollView {
            LazyVStack(spacing: 6) {
                // Gunakan filtered conversations
                ForEach(filteredHumanConversations) { conversation in
                    HumanConversationItemView(
                        conversation: conversation,
                        isSelected: viewModel.selectedConversation?.id == conversation.id
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectConversation(conversation)
                        }
                    }
                }
                
                // Empty state jika tidak ada hasil
                if filteredHumanConversations.isEmpty {
                    emptyFilterState
                }
            }
            .padding(8)
        }
        .frame(height: scrollHeight)
        .scrollIndicators(.visible)
    }
    
    private func aiConversationsScrollView(height: CGFloat) -> some View {
        let scrollHeight = max(200, (height - 300) / 2)
        
        return ScrollView {
            LazyVStack(spacing: 6) {
                // Gunakan filtered conversations
                ForEach(filteredAiConversations) { conversation in
                    AIConversationItemView(
                        conversation: conversation,
                        isSelected: viewModel.selectedConversation?.id == conversation.id
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectConversation(conversation)
                        }
                    }
                }
                
                // Empty state jika tidak ada hasil
                if filteredAiConversations.isEmpty {
                    emptyFilterState
                }
            }
            .padding(8)
        }
        .frame(height: scrollHeight)
        .scrollIndicators(.visible)
    }
    
    // Empty state view
    private var emptyFilterState: some View {
        
        VStack(spacing: 11) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundColor(Color.borderColor)
            
            Text("No conversations found")
                .font(.caption)
                .foregroundColor(Color.borderColor)
            
            if filterViewModel.hasActiveFilters {
                Button(action: {
                    filterViewModel.clearAllFilters()
                }) {
                    HStack{
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .foregroundColor(Color.tertiaryText)
                            .font(.caption)
                        Text("Clear Filters")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color.tertiaryText)
                            
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 9)
                    .background(Color.sectionHeader)
                    .cornerRadius(11)
                    
                }
                .frame(width :  110, height : 24)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 100)
    }
}

#Preview {
        ConversationListView(viewModel: ConversationListViewModel.shared)
        .frame(width : 335, height : 900)
}

