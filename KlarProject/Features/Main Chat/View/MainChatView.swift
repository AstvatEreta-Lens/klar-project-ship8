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
    @EnvironmentObject var serviceManager: ServiceManager
    @EnvironmentObject var chatViewModel: MainChatViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // ✅ ALWAYS SHOW search bar when conversation is selected
            if viewModel.selectedConversation != nil {
                HStack(spacing: 8) {
                    ConnectionStatusIndicator(status: serviceManager.connectionStatus)
                        .padding(.leading, 22)
                    Spacer()
                    
                    // ✅ ONLY show SearchBar when search is visible
                    if viewModel.isMainChatSearchVisible {
                        SearchBar(
                            text: $chatViewModel.searchText,
                            onSearch: {
                                chatViewModel.searchMessages()
                            }
                        )
                        .frame(width: 250)
                        .onChange(of: chatViewModel.searchText) { oldValue, newValue in
                            chatViewModel.searchMessages()
                        }

                        // ✅ Close button - Only clears text, doesn't hide entire bar
                        Button(action: {
                            chatViewModel.clearSearch()  // ✅ Only clear search text
//                            viewModel.isMainChatSearchVisible = false  // ✅ Hide search bar
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.backgroundPrimary)
                .zIndex(100)

                Divider()
                    .background(Color.borderColor)
                
                // Search Results Info
                if !chatViewModel.searchText.isEmpty {
                    HStack {
                        Text("\(chatViewModel.filteredMessages.count) results found")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                }
            }
            
            // Main Chat Area
            if let conversation = viewModel.selectedConversation {
                let _ = ensurePhoneNumberSet(for: conversation)
                
                VStack(spacing: 0) {
                    if chatViewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollViewReader { proxy in
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    if chatViewModel.messages.isEmpty {
                                        if chatViewModel.searchText.isEmpty {
                                            emptyStateView
                                        } else {
                                            noSearchResultsView
                                        }
                                    } else {
                                        ForEach(chatViewModel.messages) { message in
                                            MessageBubble(message: message)
                                                .id(message.id)
                                        }
                                    }
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 10)
                                .onChange(of: chatViewModel.messages.count) { oldCount, newCount in
                                    if newCount > oldCount, let lastMessage = chatViewModel.messages.last {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                            }
                                        }
                                    }
                                }
                                .onAppear {
                                    if let lastMessage = chatViewModel.messages.last {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Bottom Section
                    if shouldShowTakeOverButton(for: conversation) {
                        aiMonitoringView
                    } else {
                        ChatInputView(
                            onSend: handleSendMessage,
                            onAttachment: handleAttachment,
                            onAI: handleAI
                        )
                        .disabled(chatViewModel.isSending)
                    }
                }
            } else {
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
        .onChange(of: viewModel.selectedConversation?.phoneNumber) { oldVal, newPhoneNumber in
            if oldVal != newPhoneNumber {
                chatViewModel.clearMessages()
                chatViewModel.clearSearch()
            }
            
            if let phoneNumber = newPhoneNumber {
                print("🔄 [MAINCHAT] Conversation selected with phone: \(phoneNumber)")
                
                if let conversation = viewModel.selectedConversation {
                    viewModel.markConversationAsRead(conversation)
                }
                
                Task {
                    await chatViewModel.loadMessages(for: phoneNumber)
                }
            }
        }
        .onReceive(serviceManager.$latestMessage) { messageData in
            guard let messageData = messageData else { return }
            
            print("🔄 [MAINCHAT] Received webhook message via Publisher")
            
            chatViewModel.handleIncomingMessage(messageData)
            
            guard let messageText = messageData.text, !messageText.isEmpty else {
                viewModel.loadConversations()
                return
            }
            
            if messageData.isAIReply == true, let phoneNumber = messageData.to {
                print("🤖 [MAINCHAT] AI reply detected")
                if let aiStatus = messageData.aiStatus {
                    print("📊 [MAINCHAT] AI status from FastAPI: \(aiStatus)")
                }
                
                viewModel.handleOutgoingMessage(
                    phoneNumber: phoneNumber,
                    messageText: messageText,
                    isUserInitiated: false,
                    aiStatus: messageData.aiStatus
                )
            } else if let from = messageData.from, messageData.isFromMe != true {
                print("📱 [MAINCHAT] Customer message detected")
                viewModel.handleNewIncomingMessage(
                    phoneNumber: from,
                    messageText: messageText
                )
            } else if messageData.isFromMe == true, let to = messageData.to {
                print("👤 [MAINCHAT] Manual user message detected")
                viewModel.handleOutgoingMessage(
                    phoneNumber: to,
                    messageText: messageText,
                    isUserInitiated: true
                )
            }
        }
        .onReceive(serviceManager.$latestStatusUpdate) { statusData in
            guard let statusData = statusData else { return }
            
            print("📊 [MAINCHAT] Received status update via Publisher")
            chatViewModel.handleStatusUpdate(statusData)
        }
    }
    
    // MARK: - Subviews
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "message")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.5))
            Text("No messages yet")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Start a conversation by sending a message")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }
    
    private var noSearchResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.5))
            Text("No messages found")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Try searching with different keywords")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }
    
    private var aiMonitoringView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.blue)
                    .font(.system(size: 16))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("AI is handling this conversation")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("Monitor the conversation and take over if needed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.top, 12)
            .padding(.bottom, 12)
            
            TakeOverButton(takeoverAction: handleTakeOver)
                .frame(minWidth: 599, maxWidth: .infinity, maxHeight: 36)
                .padding(.horizontal, 16)
        }
        .background(Color.backgroundPrimary)
    }
    
    // MARK: - Helper Functions
    
    private func ensurePhoneNumberSet(for conversation: Conversation) {
        let phoneNumber = conversation.phoneNumber
        guard !phoneNumber.isEmpty else { return }
        if chatViewModel.currentPhoneNumber != phoneNumber {
            Task { await chatViewModel.loadMessages(for: phoneNumber) }
        }
    }
    
    private func shouldShowTakeOverButton(for conversation: Conversation) -> Bool {
        return conversation.handlerType == .ai &&
        (conversation.status == .open || conversation.status == .pending)
    }
    
    private func handleTakeOver() {
        viewModel.takeOverConversation()
    }
    
    private func handleSendMessage(_ message: String) {
        guard let conversation = viewModel.selectedConversation else { return }
        let phoneNumber = conversation.phoneNumber
        
        Task {
            if chatViewModel.currentPhoneNumber != phoneNumber {
                await chatViewModel.loadMessages(for: phoneNumber)
            }
            await chatViewModel.sendMessage(message)
            viewModel.handleOutgoingMessage(
                phoneNumber: phoneNumber,
                messageText: message,
                isUserInitiated: true
            )
        }
    }
    
    private func handleAttachment() { print("Attachment tapped") }
    private func handleAI() { print("AI assistant tapped") }
}
