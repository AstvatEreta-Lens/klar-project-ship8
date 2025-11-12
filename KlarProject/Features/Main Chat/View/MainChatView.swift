//
//  MainChatView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//
//
// MainChatView.swift
// MainChatView.swift
// MainChatView.swift
import SwiftUI

struct MainChatView: View {
    @EnvironmentObject var viewModel: ConversationListViewModel
    @State private var messageText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Section
            HStack {
                if let conversation = viewModel.selectedConversation {
                    if shouldShowMarkResolvedButton(for: conversation) {
                        ResolveButton(resolveAction: handleResolve)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(viewModel.isConnected ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        
                        Text(viewModel.isConnected ? "Connected" : "Disconnected")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.trailing, 8)
                    
                    SearchBar(text: .constant(""))
                        .frame(width: 206, height: 27)
                }
            }
            .padding(.leading, 22)
            .padding(.trailing, 20)
            .padding(.bottom)
            
            Divider()
            
            // Main Chat Area
            if let conversation = viewModel.selectedConversation {
                if shouldShowTakeOverButton(for: conversation) {
                    VStack {
                        Spacer()
                        
                        if !conversation.messages.isEmpty {
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(conversation.messages) { message in
                                        MessageBubbleView(message: message)
                                    }
                                }
                                .padding()
                            }
                            .opacity(0.6)
                        }
                        
                        Divider()
                        
                        Text("Currently handled by AI")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 8)
                        
                        TakeOverButton(takeoverAction: handleTakeOver)
                            .padding(.horizontal, 22)
                    }
                } else {
                    VStack(spacing: 0) {
                        ScrollViewReader { proxy in
                            ScrollView {
                                VStack(spacing: 16) {
                                    if conversation.messages.isEmpty {
                                        Text("No messages yet")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .padding(.top, 40)
                                    } else {
                                        ForEach(conversation.messages) { message in
                                            MessageBubbleView(message: message)
                                                .id(message.id)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .onChange(of: conversation.messages.count) {oldVal ,_ in
                                if let lastMessage = conversation.messages.last {
                                    withAnimation {
                                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                            .onAppear {
                                if let lastMessage = conversation.messages.last {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                        
                        Divider()
                        
                        ChatInputView(
                            messageText: $messageText,
                            onSend: handleSendMessage,
                            onAttachment: handleAttachment,
                            onAI: handleAI
                        )
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "message")
                        .font(.system(size: 64))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                    
                    Text("Select a conversation to start")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            if let error = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                    Spacer()
                    Button("Dismiss") {
                        viewModel.errorMessage = nil
                    }
                    .font(.caption)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.1))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
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
    
    private func handleSendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let conversation = viewModel.selectedConversation else {
            return
        }
        
        let text = messageText
        messageText = ""
        
        Task {
            await viewModel.sendMessage(text, to: conversation)
        }
    }
    
    private func handleAttachment() {
        print("Attachment tapped")
    }
    
    private func handleAI() {
        print("AI assistant tapped")
    }
}

struct MessageBubbleView: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            // Customer messages (isFromUser: true) → Right side
            // Our messages (isFromUser: false) → Left side
            if !message.isFromUser {
                Spacer()
            }
            
            VStack(alignment: message.isFromUser ? .leading : .trailing, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(bubbleBackground)
                    .foregroundColor(.primary)
                    .cornerRadius(16)
                    .frame(maxWidth: 300, alignment: message.isFromUser ? .leading : .trailing)
                
                HStack(spacing: 4) {
                    Text(message.timeString)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    // Show status only for our messages (outgoing)
                    if !message.isFromUser {
                        statusIcon
                    }
                }
            }
            
            if message.isFromUser {
                Spacer()
            }
        }
    }
    
    // WhatsApp-like colors
    private var bubbleBackground: Color {
        if message.isFromUser {
            // Customer message - light green/blue (WhatsApp style)
            return Color(red: 0.85, green: 0.93, blue: 0.82)
        } else {
            // Our message - gray
            return Color.gray.opacity(0.1)
        }
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        switch message.status {
        case .sending:
            Image(systemName: "clock")
                .font(.caption2)
                .foregroundColor(.secondary)
        case .sent:
            Image(systemName: "checkmark")
                .font(.caption2)
                .foregroundColor(.secondary)
        case .delivered:
            Image(systemName: "checkmark.circle")
                .font(.caption2)
                .foregroundColor(.blue)
        case .read:
            Image(systemName: "checkmark.circle.fill")
                .font(.caption2)
                .foregroundColor(.blue)
        case .failed:
            Image(systemName: "exclamationmark.circle")
                .font(.caption2)
                .foregroundColor(.red)
        }
    }
}

struct ChatInputView: View {
    @Binding var messageText: String
    let onSend: () -> Void
    let onAttachment: () -> Void
    let onAI: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onAttachment) {
                Image(systemName: "paperclip")
                    .foregroundColor(.secondary)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(PlainButtonStyle())
            
            TextField("Type a message...", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    onSend()
                }
            
            Button(action: onAI) {
                Image(systemName: "sparkles")
                    .foregroundColor(.secondary)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(messageText.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(16)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(messageText.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

#Preview {
    MainChatView()
        .environmentObject(ConversationListViewModel())
        .frame(width: 800, height: 600)
}
