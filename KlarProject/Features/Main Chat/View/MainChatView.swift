//
//  MainChatView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//
//

import SwiftUI

struct MainChatView: View {
    @EnvironmentObject var viewModel: ConversationListViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Top Section
//            HStack {
//               Text("")
//                Spacer()
//                SearchBar(text: .constant(""))
//                    .frame(width: 206, height: 27)
//            }
//            .padding(.leading, 22)
//            .padding(.trailing, 20)
//            .padding(.bottom)
//            
//           Divider()
//                .background(Color.borderColor)
//            
            // Main Chat Area
            if let conversation = viewModel.selectedConversation {
                if shouldShowTakeOverButton(for: conversation) {
                    // Show TakeOver Button for AI conversations
                    VStack {
                        Spacer()
                        Divider()
                        // AI Chat message history
                        Text("Currently handled by AI")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 8)
                        
                        TakeOverButton(takeoverAction: handleTakeOver)
                            .frame(minWidth: 599, maxWidth: .infinity, maxHeight: 36)
                            .padding(.horizontal, 16)
                        
//                        Spacer()
                    }
                } else {
                    VStack(spacing: 0) {
                        ScrollView {
                            VStack(spacing: 16) {
                                // Sample message
                                ForEach(0..<5, id: \.self) { index in
                                    MessageBubble(
                                        message: "Sample message \(index)",
                                        isFromUser: index % 2 == 0
                                    )
                                }
                            }
                            .accessibilityHidden(true)
                            .padding()
                        }
                        
                        Divider()
                        
                        // Chat Input
                        ChatInputView(
                            onSend: handleSendMessage,
//                            onAttachment: handleAttachment,
//                            onAI: handleAI,
                        )
//                        .ignoresSafeArea()
                    }
                }
            } else {
                // No conversation selected
                VStack {
                    Spacer()
                    Text("Select a conversation to start")
                        .font(.body)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
        
        .accessibilityLabel("Main Chat")
    }
    
    private func shouldShowTakeOverButton(for conversation: Conversation) -> Bool {
        return conversation.handlerType == .ai &&
               (conversation.status == .pending || conversation.status == .resolved)
    }
    
    private func handleTakeOver() {
        viewModel.takeOverConversation()
    }

    
    private func handleSendMessage(_ message: String) {
        print("Pesan terkirim: \(message)")
    }
    
    private func handleAttachment() {
        // Attachment logic
        print("Attachment tapped")
    }
    
    private func handleAI() {
        // AI suggesiton logic
        print("AI assistant tapped")
    }
}


struct MessageBubble: View {
    let message: String
    let isFromUser: Bool
    
    var body: some View {
        HStack {
            if isFromUser { Spacer() }
            
            Text(message)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isFromUser ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                .cornerRadius(5)
                .frame(maxWidth: 300, alignment: isFromUser ? .trailing : .leading)
            
            if !isFromUser { Spacer() }
        }
    }
}

#Preview {
    MainChatView()
        .environmentObject(ConversationListViewModel.shared)
        .padding()
}
