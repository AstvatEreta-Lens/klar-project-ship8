//
//  MessagingViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 06/11/25.
//

import Foundation
import Combine

@MainActor
class MessagingViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false
    @Published var isSending: Bool = false
    @Published var errorMessage: String?
    @Published var unreadCount: Int = 0
    
    
    private let conversationId: UUID
    private let currentUser: User
    private let customer: Customer
    private let service: MessageServiceProtocol
    private var observerTask: Task<Void, Never>?
    
    
    init(
        conversationId: UUID,
        currentUser: User,
        customer: Customer,
        service: MessageServiceProtocol = MockMessageService.shared
    ) {
        self.conversationId = conversationId
        self.currentUser = currentUser
        self.customer = customer
        self.service = service
        
        print("💬 MessagingViewModel: Initialized for conversation \(conversationId)")
        
        Task {
            await loadMessages()
            await startObservingMessages()
        }
    }
    
    deinit {
        observerTask?.cancel()
        print("💬 MessagingViewModel: Deinitialized")
    }
    
    // MARK: - Public Methods
    
    // Send a new message
    @discardableResult
    func sendMessage(content: String) async -> Bool {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            print("⚠️ Attempted to send empty message")
            return false
        }
        
        isSending = true
        errorMessage = nil
        
        let newMessage = Message(
            conversationId: conversationId,
            sender: .agent(currentUser),
            content: trimmed,
            timestamp: Date(),
            status: .sending
        )
        
        // Optimistic update
        messages.append(newMessage)
        print("Sending message: \(trimmed.prefix(50))...")
        
        do {
            let sentMessage = try await service.sendMessage(newMessage)
            
            // Update with sent status
            if let index = messages.firstIndex(where: { $0.id == newMessage.id }) {
                messages[index] = sentMessage
            }
            
            isSending = false
            print("✅ Message sent successfully")
            return true
            
        } catch {
            // Rollback on error
            messages.removeAll { $0.id == newMessage.id }
            errorMessage = "Failed to send message: \(error.localizedDescription)"
            isSending = false
            print("❌ Failed to send message: \(error)")
            return false
        }
    }
    
    // Load all messages for the conversation
    func loadMessages() async {
        isLoading = true
        errorMessage = nil
        
        do {
            messages = try await service.fetchMessages(conversationId: conversationId)
            updateUnreadCount()
            isLoading = false
            print("✅ Loaded \(messages.count) messages")
        } catch {
            errorMessage = "Failed to load messages: \(error.localizedDescription)"
            isLoading = false
            print("❌ Failed to load messages: \(error)")
        }
    }
    
    // Mark all messages as read
    func markAllAsRead() async {
        do {
            try await service.markAllAsRead(conversationId: conversationId)
            
            // Update local messages
            messages = messages.map { message in
                Message(
                    id: message.id,
                    conversationId: message.conversationId,
                    sender: message.sender,
                    content: message.content,
                    timestamp: message.timestamp,
                    status: .read,
                    metadata: message.metadata
                )
            }
            
            unreadCount = 0
            print("All messages marked as read")
        } catch {
            print("Failed to mark messages as read: \(error)")
        }
    }
    
    // Delete a message
    func deleteMessage(id: UUID) async {
        let deletedMessage = messages.first { $0.id == id }
        
        // Optimistic delete
        messages.removeAll { $0.id == id }
        
        do {
            try await service.deleteMessage(messageId: id)
            print("🗑️ Message deleted")
        } catch {
            // Rollback on error
            if let message = deletedMessage {
                messages.append(message)
                messages.sort { $0.timestamp < $1.timestamp }
            }
            errorMessage = "Failed to delete message"
            print("❌ Failed to delete message: \(error)")
        }
    }
    
    /// Retry sending a failed message
    func retryMessage(_ message: Message) async {
        guard message.hasFailed else { return }
        
        // Remove failed message
        messages.removeAll { $0.id == message.id }
        
        // Resend
        await sendMessage(content: message.content)
    }
    
    // MARK: - Private Methods
    
    // Start observing new messages in real-time
    private func startObservingMessages() async {
        observerTask?.cancel()
        
        observerTask = Task {
            do {
                let stream = try await service.observeMessages(conversationId: conversationId)
                
                for await newMessage in stream {
                    // Add new message if not already in list
                    if !messages.contains(where: { $0.id == newMessage.id }) {
                        messages.append(newMessage)
                        messages.sort { $0.timestamp < $1.timestamp }
                        updateUnreadCount()
                        print("📨 New message received: \(newMessage.content.prefix(50))...")
                    }
                }
            } catch {
                print("Error observing messages: \(error)")
            }
        }
    }
    
    // Update unread message count
    private func updateUnreadCount() {
        unreadCount = messages.filter { message in
            message.isFromCustomer && message.status != .read
        }.count
    }
    
    // MARK: - Computed Properties
    
    // Get the ID of the last message for scrolling
    var lastMessageId: UUID? {
        messages.last?.id
    }
    
    // Check if there are any messages
    var hasMessages: Bool {
        !messages.isEmpty
    }
    
    // Get message count
    var messageCount: Int {
        messages.count
    }
    
    // Get grouped messages by date
    var groupedMessages: [(date: String, messages: [Message])] {
        let grouped = Dictionary(grouping: messages) { message -> String in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: message.timestamp)
        }
        
        return grouped.map { (date: $0.key, messages: $0.value.sorted { $0.timestamp < $1.timestamp }) }
            .sorted { $0.messages.first?.timestamp ?? Date() < $1.messages.first?.timestamp ?? Date() }
    }
}
