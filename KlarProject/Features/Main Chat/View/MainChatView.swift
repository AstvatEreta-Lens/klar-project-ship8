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
    @StateObject private var chatViewModel = MainChatViewModel()

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.selectedConversation != nil && viewModel.isMainChatSearchVisible {
                HStack(spacing: 8) {
                    Spacer()
                    SearchBar(
                        text: $viewModel.mainChatSearchText,
                        onSearch: {
                            chatViewModel.searchText = viewModel.mainChatSearchText
                            chatViewModel.searchMessages()
                        }
                    )
                    .frame(width: 250)

                    // Close button
                    Button(action: {
                        viewModel.isMainChatSearchVisible = false
                        viewModel.mainChatSearchText = ""
                        chatViewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.backgroundPrimary)
                .zIndex(100)

                Divider()
                    .background(Color.borderColor)
            }

            // Main Chat Area
            // kalau mau ganti semua jadi pakai textfield, hapus if else nya aja
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
                        if chatViewModel.isLoadingMessages {
                            // Loading state
                            VStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                Text("Loading messages...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)
                                Spacer()
                            }
                        } else {
                            ScrollViewReader { scrollProxy in
                                ScrollView {
                                    VStack(spacing: 16) {
                                        // Display filtered messages
                                        ForEach(chatViewModel.filteredMessages) { message in
                                            MessageBubble(
                                                message: message.content,
                                                isFromUser: message.isFromCustomer,
                                                timestamp: message.formattedTime,
                                                senderName: message.sender.displayName,
                                                searchText: chatViewModel.searchText
                                            )
                                            .id(message.id)
                                        }

                                        // Empty state when search has no results
                                        if chatViewModel.filteredMessages.isEmpty && !chatViewModel.searchText.isEmpty {
                                            VStack(spacing: 12) {
                                                Image(systemName: "magnifyingglass")
                                                    .font(.system(size: 48))
                                                    .foregroundColor(.gray)

                                                Text("No messages found")
                                                    .font(.headline)
                                                    .foregroundColor(.secondary)

                                                Text("Try a different search term")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(.vertical, 40)
                                        }

                                        // Empty state when no messages at all
                                        if chatViewModel.messages.isEmpty && chatViewModel.searchText.isEmpty {
                                            VStack(spacing: 12) {
                                                Image(systemName: "message")
                                                    .font(.system(size: 48))
                                                    .foregroundColor(.gray)

                                                Text("No messages yet")
                                                    .font(.headline)
                                                    .foregroundColor(.secondary)

                                                Text("Start a conversation")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(.vertical, 40)
                                        }
                                    }
                                    .padding()
                                }
                                .onChange(of: chatViewModel.messages.count) { _ in
                                    if let lastMessage = chatViewModel.messages.last {
                                        withAnimation {
                                            scrollProxy.scrollTo(lastMessage.id, anchor: .bottom)
                                        }
                                    }
                                }
                            }

                            Divider()

                            // Chat Input
                            ChatInputView(
                                onSend: handleSendMessage
                            )
                        }
                    }
                    .onAppear {
                        chatViewModel.loadMessages(for: conversation)
                    }
                    .onChange(of: conversation.id) { _ in
                        chatViewModel.loadMessages(for: conversation)
                    }
                    .onChange(of: viewModel.mainChatSearchText) { _ in
                        chatViewModel.searchText = viewModel.mainChatSearchText
                    }
                }
            } else {
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
        chatViewModel.sendMessage(content: message, from: viewModel.currentUser)
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
    let timestamp: String
    let senderName: String
    let searchText: String

    var body: some View {
        HStack(alignment: .bottom) {
            if isFromUser { Spacer() }

            VStack(alignment: isFromUser ? .trailing : .leading, spacing: 4) {
                // Sender name
                Text(senderName)
                    .font(.caption)
                    .foregroundColor(Color(hex: "#3E3E3E"))

                // Message bubble with highlighted text
                HighlightedText(
                    text: message,
                    searchText: searchText,
                    highlightColor: Color.yellow.opacity(0.5)
                )
                .font(.body)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isFromUser ? Color(hex: "#C0E3FF") : Color(hex: "#F5F5F5"))
                .cornerRadius(12)
                .frame(maxWidth: 200, alignment: isFromUser ? .trailing : .leading)

                // Timestamp
                Text(timestamp)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#8E8E8E"))
            }

            if !isFromUser { Spacer() }
        }
    }
}

#Preview {
    MainChatView()
        .environmentObject(ConversationListViewModel.shared)
        .padding()
}
