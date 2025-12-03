//
//  ConversationListView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 05/11/25.
//
import SwiftUI

struct ConversationListView: View {
    @EnvironmentObject var viewModel: ConversationListViewModel
    @StateObject private var filterViewModel = FilterViewModel()
    @State private var showingFilter = false
    @State private var showNewConversationDialog = false
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
                        )
                        {
                            humanConversationsScrollView(height: geometry.size.height)
                        }
                        .accessibilityLabel("Ai Chat scroll view")
                        
                        // AI Section
                        ConversationSection(
                            title: NSLocalizedString("HANDLED BY AI", comment: ""),
                            count: viewModel.unresolvedCount,
                            viewModel: viewModel
                        ){
                            aiConversationsScrollView(height: geometry.size.height)
                        }
                        .accessibilityLabel("Ai Chat scroll view")
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.backgroundPrimary)
                .zIndex(0) // Base content layer
                
                // Filter Overlay - Dimmed Background
                if showingFilter {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showingFilter = false
                            }
                        }
                        .zIndex(1) // Overlay layer
                    
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
                            .background(Color.backgroundPrimary)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(
                                    cornerRadius: 12
                                )
                                .stroke(Color.sectionHeader, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
                            .transition(.move(edge: .trailing))
                        }
                        Spacer()
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .padding(.top, 90)
                    .padding(.trailing, 15)
                    .zIndex(2)
                }
                
                // New Conversation Dialog
                if showNewConversationDialog {
                    Color.black
                        .opacity(0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showNewConversationDialog = false
                            }
                        }
                        .zIndex(98)
                    
                    NewConversationDialog(
                        isPresented: $showNewConversationDialog,
                        onStartConversation: { phoneNumber, name in
                            await viewModel.startNewConversation(phoneNumber: phoneNumber, customName: name)
                        }
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .zIndex(99) // Dialog di atas filter panel
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
                .foregroundColor(Color.sectionHeader)
            
            HStack {
                SearchBar(
                    text: $viewModel.searchText,
                    onSearch: {
                        viewModel.searchConversations()
                    }
                )
                
                // New Conversation Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showNewConversationDialog = true
                    }
                }) {
                    Image(systemName: "plus.message.fill")
                        .foregroundColor(Color.primaryText)
                        .font(.system(size: 14))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 8)
                
                // Filter Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingFilter.toggle()
                    }
                }) {
                    ZStack {
                        Image(systemName: "slider.horizontal.3")
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
                    isSelected: viewModel.selectedFilter == "Unread"
                ) {
                    viewModel.applyFilter("Unread")
                }
                
                FilterButton(
                    title: String(localized : "Unresolved", comment: ""),
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
                        isSelected: viewModel.selectedConversation?.id == conversation.id,
                        viewModel : viewModel
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
            .accessibilityLabel("Human Chat scroll view")
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
                        isSelected: viewModel.selectedConversation?.id == conversation.id,
                        viewModel: viewModel
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
            .accessibilityLabel("Ai Chat scroll view")
            .padding(8)
        }
        .frame(height: scrollHeight)
        .scrollIndicators(.visible)
    }
    
    // Empty state view
    private var emptyFilterState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No conversations found")
                .font(.headline)
                .foregroundColor(.gray)
            
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
        .padding(.vertical, 40)
    }
}
