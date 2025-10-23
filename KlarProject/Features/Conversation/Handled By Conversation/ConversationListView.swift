//
//  HandledByView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/10/25.
//

import SwiftUI

struct ConversationListView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @Binding var selectedConversation: Conversation? // Binding dari parent
    
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Conversation")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.horizontal, 10)
                
                HStack {
                    SearchBar(text : $searchText){
                        // Trigger search
                    }
                    
                    // Filter Button
                    Button(action: {
                        print("Filter Button Clicked")
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.black)
                            .padding(.trailing, 21)
                            .padding(.leading, 5)
                            .background(Color.white)
                            .cornerRadius(5)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.leading, 10)
                
                HStack(spacing: 7) {
                    FilterButton(title: "All", isSelected: selectedFilter == "All") {
                        selectedFilter = "All"
                    }
                    
                    FilterButton(
                        title: "Unread",
                        count: unreadCount,
                        isSelected: selectedFilter == "Unread"
                    ) {
                        selectedFilter = "Unread"
                    }
                    
                    FilterButton(
                        title: "Unresolved",
                        count: unresolvedCount + unreadCount,
                        isSelected: selectedFilter == "Unresolved"
                    ) {
                        selectedFilter = "Unresolved"
                    }
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 7)
            }
            .padding(.vertical, 8)
            
            VStack(spacing: 0) {
                
                // HANDLED BY HUMAN AGENTS Section
                SectionHeader(title: "HANDLED BY HUMAN AGENTS")
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 1)
                        ForEach(filterHumanConvo) { conversation in
                            HumanConversationItemView(conversation: conversation)
                                .onTapGesture {
                                    selectedConversation = conversation
                                    print("Tapped!")
                                }
                                .background(
                                    selectedConversation?.id == conversation.id ?
                                    Color.chatChosenColor : Color.white
                                )
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .layoutPriority(1)
                
                // HANDLED BY AI Section
                SectionHeader(title: "HANDLED BY AI")
                    .padding(.top, 1)
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 1)
                        ForEach(filterAiConvo) { conversation in
                            AIConversationItemView(conversation: conversation)
                                .onTapGesture {
                                    selectedConversation = conversation
                                    print("Tapped!")
                                }
                                .background(
                                    selectedConversation?.id == conversation.id ?
                                    Color.chatChosenColor : Color.white
                                )
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .layoutPriority(1)
                
            }
        }
        .frame(width: 314, height: 912)
        .overlay(
            UnevenRoundedRectangle(
                topLeadingRadius: 12,
                bottomLeadingRadius: 12,
                bottomTrailingRadius: 0,
                topTrailingRadius: 0
            )
            .stroke(style: StrokeStyle(lineWidth: 1))
        )
        .padding(1)
    }
    
    
    // MARK: Semua Filter ada disini
    
    // Count Chat
    private var allChat : [Conversation]{
        Conversation.aiDummy + Conversation.dummyData
    }
    
    private var unreadCount: Int {
        Conversation.dummyData.filter { $0.unreadCount > 0 }.count
    }
    
    private var unresolvedCount: Int {
        Conversation.aiDummy.filter { conversation in
            if let status = conversation.status {
                return status == .pending || status == .open
            }
            return false
        }.count
    }
    
    // Sort Chat
    private var sortedHumanConversations: [Conversation] {
        Conversation.dummyData.sorted { conv1, conv2 in
            // Descending
            conv1.timeInMinutes > conv2.timeInMinutes
        }
    }
    
    private var sortedAiConversations : [Conversation]{
        Conversation.aiDummy.sorted { conv1, conv2 in
            if conv1.sortPriority != conv2.sortPriority {
                    return conv1.sortPriority < conv2.sortPriority
            }
            return conv1.timeInMinutes > conv2.timeInMinutes
        }
    }
    
    // Filter disini untuk show mana aja yang termasuk filter
    private var filterHumanConvo: [Conversation]{
        let sorted = sortedHumanConversations
        
        switch selectedFilter {
        case "Unread" :
            return sorted.filter { $0.unreadCount > 0}
        default :
            return sorted
        }
    }
    
    private var filterAiConvo: [Conversation]{
        let sorted = sortedAiConversations
        
        switch selectedFilter{
        case "Resolved" :
            return sorted.filter { $0.unreadCount > 0}
        case "Unresolved" :
            return sorted.filter { conversation in
            if let status = conversation.status {
                return status == .pending || status == .open
            }
            return false
        }
        default :
            return sorted
        }
    }
}




#Preview {
    @Previewable @State var selectedConv: Conversation? = nil
    ConversationListView(selectedConversation: $selectedConv)
}

