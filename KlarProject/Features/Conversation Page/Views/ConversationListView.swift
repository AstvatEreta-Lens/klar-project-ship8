//
//  ConversationListView.swift
//  KlarProject
//
//
//  ConversationListView.swift
//  KlarProject
//

import SwiftUI

struct ConversationListView: View {
    @ObservedObject var viewModel: ConversationListViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                headerSection
                
                VStack(spacing: 12) {
                    // Human Agents Section
                    ConversationSection(title: "HANDLED BY HUMAN AGENTS") {
                        humanConversationsScrollView(height: geometry.size.height)
                    }
                    
                    // AI Section
                    ConversationSection(title: "HANDLED BY AI") {
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
                SearchBar(text: $viewModel.searchText) {
                    viewModel.searchConversations()
                }
                
                Button(action: {
                    print("Filter Button Clicked")
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(Color.primaryText)
                        .padding(.trailing, 25)
                        .padding(.leading, 15)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 14)
            
            // Filter Buttons
            HStack(spacing: 7) {
                FilterButton(title: "All", isSelected: viewModel.selectedFilter == "All") {
                    viewModel.applyFilter("All")
                }
                
                FilterButton(
                    title: "Unread",
                    count: viewModel.unreadCount,
                    isSelected: viewModel.selectedFilter == "Unread"
                ) {
                    viewModel.applyFilter("Unread")
                }
                
                FilterButton(
                    title: "Unresolved",
                    count: viewModel.unresolvedCount,
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
                ForEach(viewModel.filterHumanConvo) { conversation in
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
                ForEach(viewModel.filterAiConvo) { conversation in
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
            }
            .padding(8)
        }
        .frame(height: scrollHeight)
        .scrollIndicators(.visible)
    }
}

#Preview {
    ConversationListView(viewModel: ConversationListViewModel())
}
