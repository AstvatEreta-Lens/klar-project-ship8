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
            HStack {
                if let conversation = viewModel.selectedConversation {
                    if shouldShowMarkResolvedButton(for: conversation) {
                        ResolveButton(resolveAction: handleResolve)
                    }
                    else {
                        Text("hohoho")
                    }
                }
                Spacer()
                SearchBar(text: .constant(""))
                    .frame(width: 206, height: 27)
            }
            .padding(.leading, 22)
            .padding(.trailing, 20)
            .padding(.bottom)
            
            Divider()
            
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
                            .padding(.horizontal, 22)
                        
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
                            .padding()
                        }
                        
                        Divider()
                        
                        // Chat Input
                        ChatInputView(
                            onSend: handleSendMessage,
                            onAttachment: handleAttachment,
                            onAI: handleAI
                        )
                    }
                }
            } else {
                // No conversation selected
                VStack {
                    Spacer()
                    Text("Select a conversation to start")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
    
    private func shouldShowTakeOverButton(for conversation: Conversation) -> Bool {
        return conversation.handlerType == .ai &&
               (conversation.status == .pending || conversation.status == .open)
    }
    
    private func shouldShowMarkResolvedButton(for conversation: Conversation) -> Bool {
        return conversation.handlerType == .human
    }
    
    private func handleTakeOver() {
        viewModel.takeOverConversation()
    }
    
    private func handleResolve() {
        viewModel.resolveConversation()
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
        .environmentObject(ConversationListViewModel())
        .padding()
}
