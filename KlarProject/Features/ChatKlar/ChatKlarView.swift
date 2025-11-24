//
//  ChatKlarView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//  Updated with TakeOver functionality
//

import SwiftUI

struct ChatKlarView: View {
    @ObservedObject private var viewModel = ConversationListViewModel.shared
    @ObservedObject private var evaluationViewModel = EvaluationViewModel.shared

    var body: some View {
        GeometryReader { geometry in
            // Layout constants hoisted to GeometryReader scope
            let maxTotalWidth: CGFloat = 2400
            let sidebarWidth: CGFloat = max(300, min(350, geometry.size.width * 0.25))
            let totalWidth: CGFloat = min(geometry.size.width, maxTotalWidth)
            let centerWidth: CGFloat = totalWidth - (sidebarWidth * 2) - 2 // Account for 2 dividers
            
            HStack {
                Spacer()
                
                HStack(spacing: 0) {
                    
                    ConversationListView(viewModel: viewModel)
                        .frame(width: sidebarWidth)
                        .frame(maxHeight: .infinity, alignment: .top)

                    Divider()
                        .frame(maxHeight: .infinity)
                        .background(Color.borderColor)

                    // MARK: - Main Chat (Center Content)
                    if viewModel.selectedConversation != nil {
                        MainChatView()
                            .environmentObject(viewModel)
                            .padding(.top, 12)
                            .frame(width: centerWidth)
                            .frame(maxHeight: .infinity)
                    } else {
                        // Empty state
                        VStack(spacing : 10){
                            Image("Logo Placeholder No Convo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 213, height : 48)
//                                .padding(.bottom, 290)

                            Text("Select a conversation to see message.")
                                .font(.caption)
                                .foregroundColor(.sectionHeader)
                        }
                        .frame(width: centerWidth + sidebarWidth + 1)
                        .frame(maxHeight: .infinity)
                        .background(Color.backgroundPrimary)
                    }

                    // MARK: - Chat Detail (Right Sidebar) - Only show when conversation is selected
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
        .environmentObject(viewModel)
        .environmentObject(evaluationViewModel)
        .toast(manager: viewModel.toastManager)
    }
}

#Preview {
    ChatKlarView()
        .frame(width: 1400, height: 982)
}
