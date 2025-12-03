//
//  ChatKlarView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//  Updated with TakeOver functionality
//

import SwiftUI

struct ChatKlarView: View {
    @EnvironmentObject var viewModel: ConversationListViewModel
    @EnvironmentObject var serviceManager: ServiceManager
    @EnvironmentObject var evaluationViewModel: EvaluationViewModel
    @StateObject private var chatViewModel = MainChatViewModel()
    @State private var showNewConversationDialog = false
    
    var body: some View {
        GeometryReader { geometry in
            // Layout constants hoisted to GeometryReader scope
            let maxTotalWidth: CGFloat = 2400
            let sidebarWidth: CGFloat = max(300, min(350, geometry.size.width * 0.25))
            let totalWidth: CGFloat = min(geometry.size.width, maxTotalWidth)
            let centerWidth: CGFloat = totalWidth - (sidebarWidth * 2) - 2 // Account for 2 dividers
            
            HStack{
                Spacer()
                HStack(spacing: 0) {
                    
                    // MARK: -Conversation List
                    ConversationListView(viewModel: _viewModel)
                        .frame(width: sidebarWidth)
                        .frame(maxHeight: .infinity, alignment: .top)
                    
                    Divider()
                        .frame(maxHeight: .infinity)
                        .background(Color.borderColor)
                    
                    // MARK: -Main Chat
                    if viewModel.selectedConversation != nil {
                        MainChatView()
                            .environmentObject(viewModel)
                            .environmentObject(chatViewModel)
                            .padding(.top, 12)
                            .frame(width: centerWidth)
                            .frame(maxHeight: .infinity)
                    } else {
                        // Empty state
                        VStack(spacing: 10) {
                            Image("Logo Placeholder No Convo")
                                .font(.system(size: 64))
                                .foregroundColor(.gray.opacity(0.3))
                            
                            Text("Select a conversation to see message")
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                        .frame(width: centerWidth + sidebarWidth + 1)
                        .frame(maxHeight: .infinity)
                        .background(Color.backgroundPrimary)
                    }
                    

                    
                    // MARK: -Chat Detail
                    if let conversation = viewModel.selectedConversation {
                        Divider()
                            .frame(maxHeight: .infinity)
                            .background(Color.borderColor)
                        
                        ChatDetailView(
                            conversation: conversation,
                            onConversationUpdated: { updatedConversation in
                                viewModel.updateConversation(updatedConversation)
                            }
                        )
                        .environmentObject(chatViewModel)  
                        .frame(width: sidebarWidth)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .id(conversation.id)
                    }
                }
                .frame(width: totalWidth)
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.backgroundPrimary)
            
        }
        .accessibilityLabel("Main chat")
    }
}

#Preview {
    ChatKlarView()
        .frame(width: 1400, height: 982)
}
