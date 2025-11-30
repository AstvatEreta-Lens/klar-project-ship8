//
//  MainChatViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI
import Combine

@MainActor
class MainChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var searchText: String = ""
    @Published var isLoadingMessages: Bool = false
    @Published var currentConversation: Conversation?

    private let messageService = MockMessageService.shared
    private var messageObserverTask: Task<Void, Never>?

    // Filtered messages based on search text, sorted with matches at the top
    var filteredMessages: [Message] {
        if searchText.isEmpty {
            return messages
        }

        let filtered = messages.filter { message in
            message.content.localizedCaseInsensitiveContains(searchText)
        }

        // Sort so messages with matches appear at the top
        // Keep chronological order within matched and non-matched groups
        return filtered.sorted { msg1, msg2 in
            let msg1HasMatch = msg1.content.localizedCaseInsensitiveContains(searchText)
            let msg2HasMatch = msg2.content.localizedCaseInsensitiveContains(searchText)

            if msg1HasMatch && !msg2HasMatch {
                return true // msg1 comes first
            } else if !msg1HasMatch && msg2HasMatch {
                return false // msg2 comes first
            } else {
                return msg1.timestamp < msg2.timestamp // Keep chronological order
            }
        }
    }

    // Load messages for a conversation
    func loadMessages(for conversation: Conversation) {
        guard currentConversation?.id != conversation.id else {
            return
        }

        currentConversation = conversation
        isLoadingMessages = true

        // Cancel previous observer
        messageObserverTask?.cancel()

        Task {
            do {
                // Fetch existing messages
                let fetchedMessages = try await messageService.fetchMessages(conversationId: conversation.id)

                await MainActor.run {
                    self.messages = fetchedMessages
                    self.isLoadingMessages = false
                    print("\(fetchedMessages.count) messages for \(conversation.name)")
                }

                // If no messages exist, populate with dummy data for testing
                if fetchedMessages.isEmpty {
                    populateTestMessages(for: conversation)
                }

                // Start observing for new messages
                startObservingMessages(conversationId: conversation.id)

            } catch {
                await MainActor.run {
                    self.isLoadingMessages = false
                    print("Error loading messages: \(error)")
                }
            }
        }
    }

    // Send a new message
    func sendMessage(content: String, from user: User) {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let conversation = currentConversation else {
            return
        }

        let newMessage = Message(
            conversationId: conversation.id,
            sender: .agent(user),
            content: content,
            timestamp: Date(),
            status: .sending,
            metadata: MessageMetadata(platform: "WhatsApp")
        )

        // Optimistically add message to UI
        messages.append(newMessage)

        Task {
            do {
                let sentMessage = try await messageService.sendMessage(newMessage)

                // Update the message with sent status
                if let index = messages.firstIndex(where: { $0.id == newMessage.id }) {
                    messages[index] = sentMessage
                }

                print("Message sent successfully")
            } catch {
                // Update message to failed status
                if let index = messages.firstIndex(where: { $0.id == newMessage.id }) {
                    var failedMessage = messages[index]
                    failedMessage = Message(
                        id: failedMessage.id,
                        conversationId: failedMessage.conversationId,
                        sender: failedMessage.sender,
                        content: failedMessage.content,
                        timestamp: failedMessage.timestamp,
                        status: .failed,
                        metadata: failedMessage.metadata
                    )
                    messages[index] = failedMessage
                }
                print("Failed to send message: \(error)")
            }
        }
    }

    // Search within current conversation messages
    func searchMessages() {
        if searchText.isEmpty {
            print("\(messages.count) messages")
        } else {
            print("'\(searchText)', found \(filteredMessages.count) matches")
        }
    }

    // Clear search
    func clearSearch() {
        searchText = ""
    }

    // MARK: - Private Methods

    private func startObservingMessages(conversationId: UUID) {
        messageObserverTask = Task {
            do {
                let stream = try await messageService.observeMessages(conversationId: conversationId)

                for await newMessage in stream {
                    // Add new message if not already in list
                    if !messages.contains(where: { $0.id == newMessage.id }) {
                        messages.append(newMessage)
                        print("Received new message: \(newMessage.content.prefix(50))...")
                    }
                }
            } catch {
                print("Error observing messages: \(error)")
            }
        }
    }

    private func populateTestMessages(for conversation: Conversation) {
        // Create a customer from conversation data
        let customer = Customer(
            name: conversation.name,
            phoneNumber: conversation.phoneNumber,
            profileImage: conversation.profileImage
        )

        messageService.populateTestMessages(
            conversationId: conversation.id,
            customer: customer,
            agent: conversation.handledBy
        )

        // Reload messages
        Task {
            do {
                let fetchedMessages = try await messageService.fetchMessages(conversationId: conversation.id)
                await MainActor.run {
                    self.messages = fetchedMessages
                }
            } catch {
                print("Error reloading messages: \(error)")
            }
        }
    }

    // Clean up when view disappears
    func cleanup() {
        messageObserverTask?.cancel()
        messageObserverTask = nil
    }

    deinit {
        messageObserverTask?.cancel()
    }
}
