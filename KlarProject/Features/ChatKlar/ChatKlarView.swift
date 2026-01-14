//
//  ChatKlarView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//  Updated with TakeOver functionality
//

import SwiftUI

struct ChatKlarView: View {
    @StateObject private var viewModel = ConversationListViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // MARK: -Conversation List
                ConversationListView(viewModel: viewModel)
                    .frame(width: 334)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                Divider()
                    .frame(height: geometry.size.height)
                
                // MARK: -Main Chat
                if viewModel.selectedConversation != nil {
                    MainChatView()
                        .environmentObject(viewModel)
                        .padding(.top, 12)
                        .padding(.bottom, 12)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Empty state
                    VStack(spacing: 363) {
                        Image("Logo")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text("Select a conversation to see message")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.backgroundPrimary)
                }
                
                Divider()
                    .frame(height: geometry.size.height)
                
                // MARK: -Chat Detail
                if let conversation = viewModel.selectedConversation {
                    ChatDetailView(conversation: conversation)
                        .frame(width: 334)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .id(conversation.id)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.backgroundPrimary)
        }
    }
}

#Preview {
    ChatKlarView()
        .frame(width: 1400, height: 982)
}
