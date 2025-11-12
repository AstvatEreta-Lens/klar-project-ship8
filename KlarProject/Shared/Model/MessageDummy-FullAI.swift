//
//  MessageDummy.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 06/11/25.
//


import Foundation

// MARK: - Message Service Protocol
protocol MessageServiceProtocol {
    // Fetch messages for a conversation
    func fetchMessages(conversationId: UUID) async throws -> [Message]
    
    // Send a new message
    func sendMessage(_ message: Message) async throws -> Message
    
    // Mark message as read
    func markAsRead(messageId: UUID) async throws
    
    // Mark all messages as read for a conversation
    func markAllAsRead(conversationId: UUID) async throws
    
    // Delete a message
    func deleteMessage(messageId: UUID) async throws
    
    // Update message status
    func updateMessageStatus(messageId: UUID, status: MessageStatus) async throws
    
    // Listen for new messages (real-time updates)
    func observeMessages(conversationId: UUID) async throws -> AsyncStream<Message>
}

// MARK: - Mock Message Service (Local Implementation)

@MainActor
class MockMessageService: MessageServiceProtocol {
    static let shared = MockMessageService()
    
    // In-memory storage (simulating database)
    private var messagesStore: [UUID: [Message]] = [:]
    private var messageStatusStore: [UUID: MessageStatus] = [:]
    
    // For simulating real-time updates
    private var messageStreams: [UUID: AsyncStream<Message>.Continuation] = [:]
    
    private init() {
        // Load some dummy data
        loadDummyData()
    }
    
    // MARK: - Protocol Implementation
    
    func fetchMessages(conversationId: UUID) async throws -> [Message] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        print("📨 MockService: Fetching messages for conversation \(conversationId)")
        
        let messages = messagesStore[conversationId] ?? []
        print("📨 MockService: Found \(messages.count) messages")
        
        return messages.sorted { $0.timestamp < $1.timestamp }
    }
    
    func sendMessage(_ message: Message) async throws -> Message {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        print("📤 MockService: Sending message: \(message.content.prefix(50))...")
        
        var updatedMessage = message
        updatedMessage = Message(
            id: message.id,
            conversationId: message.conversationId,
            sender: message.sender,
            content: message.content,
            timestamp: message.timestamp,
            status: .sent, // Update status to sent
            metadata: message.metadata
        )
        
        // Store message
        if messagesStore[message.conversationId] != nil {
            messagesStore[message.conversationId]?.append(updatedMessage)
        } else {
            messagesStore[message.conversationId] = [updatedMessage]
        }
        
        // Notify observers
        if let continuation = messageStreams[message.conversationId] {
            continuation.yield(updatedMessage)
        }
        
        // Simulate customer reply after agent message
        if !updatedMessage.isFromCustomer {
            Task {
                try await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
                await simulateCustomerReply(conversationId: message.conversationId)
            }
        }
        
        print("✅ MockService: Message sent successfully")
        return updatedMessage
    }
    
    func markAsRead(messageId: UUID) async throws {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        messageStatusStore[messageId] = .read
        print("👁️ MockService: Message \(messageId) marked as read")
    }
    
    func markAllAsRead(conversationId: UUID) async throws {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        guard var messages = messagesStore[conversationId] else { return }
        
        messages = messages.map { message in
            var updated = message
            return Message(
                id: updated.id,
                conversationId: updated.conversationId,
                sender: updated.sender,
                content: updated.content,
                timestamp: updated.timestamp,
                status: .read,
                metadata: updated.metadata
            )
        }
        
        messagesStore[conversationId] = messages
        print("👁️ MockService: All messages marked as read for conversation \(conversationId)")
    }
    
    func deleteMessage(messageId: UUID) async throws {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        for (conversationId, messages) in messagesStore {
            let filtered = messages.filter { $0.id != messageId }
            if filtered.count != messages.count {
                messagesStore[conversationId] = filtered
                print("🗑️ MockService: Message \(messageId) deleted")
                return
            }
        }
    }
    
    func updateMessageStatus(messageId: UUID, status: MessageStatus) async throws {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        for (conversationId, messages) in messagesStore {
            if let index = messages.firstIndex(where: { $0.id == messageId }) {
                var updated = messages[index]
                updated = Message(
                    id: updated.id,
                    conversationId: updated.conversationId,
                    sender: updated.sender,
                    content: updated.content,
                    timestamp: updated.timestamp,
                    status: status,
                    metadata: updated.metadata
                )
                messagesStore[conversationId]?[index] = updated
                print("📊 MockService: Message status updated to \(status)")
                return
            }
        }
    }
    
    func observeMessages(conversationId: UUID) async throws -> AsyncStream<Message> {
        print("👀 MockService: Starting to observe messages for conversation \(conversationId)")
        
        return AsyncStream { continuation in
            messageStreams[conversationId] = continuation
            
            continuation.onTermination = { @Sendable _ in
                Task { @MainActor in
                    self.messageStreams.removeValue(forKey: conversationId)
                    print("🛑 MockService: Stopped observing conversation \(conversationId)")
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadDummyData() {
        // This will be populated when conversations are viewed
        print("💾 MockService: Initialized")
    }
    
    /// Simulate customer replying to agent message
    private func simulateCustomerReply(conversationId: UUID) async {
        let replies = [
            "Oke min, terima kasih!",
            "Baik, saya tunggu ya",
            "Alamat saya di Jl. Sudirman No. 123, Jakarta Pusat",
            "Berapa biaya servicenya min?",
            "Oke noted, terima kasih banyak!"
        ]
        
        // Get customer from existing messages
        guard let messages = messagesStore[conversationId],
              let firstMessage = messages.first,
              case .customer(let customer) = firstMessage.sender else {
            return
        }
        
        let randomReply = replies.randomElement() ?? "Oke min"
        
        let customerMessage = Message(
            conversationId: conversationId,
            sender: .customer(customer),
            content: randomReply,
            timestamp: Date(),
            status: .sent,
            metadata: MessageMetadata(platform: "WhatsApp")
        )
        
        // Add to store
        messagesStore[conversationId]?.append(customerMessage)
        
        // Notify observers
        if let continuation = messageStreams[conversationId] {
            continuation.yield(customerMessage)
        }
        
        print("🤖 MockService: Simulated customer reply: \(randomReply)")
    }
    
    // MARK: - Development Helpers
    
    // Populate messages for a conversation (for testing)
    func populateTestMessages(conversationId: UUID, customer: Customer, agent: User) {
        let messages = Message.dummyMessages(
            conversationId: conversationId,
            customer: customer,
            agent: agent
        )
        messagesStore[conversationId] = messages
        print("📝 MockService: Populated \(messages.count) test messages")
    }
    
    // Clear all messages (for testing)
    func clearAllMessages() {
        messagesStore.removeAll()
        messageStatusStore.removeAll()
        print("🗑️ MockService: All messages cleared")
    }
    
    // Get message count for conversation
    func getMessageCount(conversationId: UUID) -> Int {
        messagesStore[conversationId]?.count ?? 0
    }
}

// MARK: - Service Error

enum MessageServiceError: LocalizedError {
    case networkError
    case unauthorized
    case messageNotFound
    case invalidMessage
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection error"
        case .unauthorized:
            return "You are not authorized to perform this action"
        case .messageNotFound:
            return "Message not found"
        case .invalidMessage:
            return "Invalid message format"
        case .unknown(let error):
            return "An error occurred: \(error.localizedDescription)"
        }
    }
}
