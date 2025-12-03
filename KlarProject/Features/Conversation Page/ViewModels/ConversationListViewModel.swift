//
//  ConversationListViewModel.swift
//  KlarProject
//
// Created by Nicholas Tristandi on 28/10/25.
//

import SwiftUI
import Combine

@MainActor
class ConversationListViewModel: ObservableObject {
    static let shared = ConversationListViewModel()


    @Published var selectedConversation: Conversation?
    @Published var humanConversations: [Conversation] = []
    @Published var aiConversations: [Conversation] = []
    @Published var searchText: String = ""
    @Published var selectedFilter: String = "All"
    @Published var toastManager = ToastManager()
    @Published var conversationsMatchingSearch: Set<UUID> = []
    @Published var isMainChatSearchVisible: Bool = true
    @Published var mainChatSearchText: String = ""
    @Published var matchingMessagePreviews: [UUID: String] = [:] // Stores most recent matching message per conversation

    private let messageService = MockMessageService.shared

    // Current logged in user
    var currentUser: User = User(
        name: "Current User",
        profileImage: "user-avatar",
        email: "user@example.com"
    )

    // Filtered human conversations (by search text)
    var filterHumanConvo: [Conversation] {
        var filtered = humanConversations

        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { conversation in
                // Search in conversation metadata
                let matchesMetadata = conversation.name.localizedCaseInsensitiveContains(searchText) ||
                    conversation.message.localizedCaseInsensitiveContains(searchText)

                // Also check if conversation ID is in the set of conversations with matching messages
                let matchesMessages = conversationsMatchingSearch.contains(conversation.id)

                return matchesMetadata || matchesMessages
            }
        }

        // Apply button filter (All, Unread, Unresolved)
        filtered = applyButtonFilter(to: filtered)

        return filtered
    }

    // Filtered AI conversations (by search text and sorted by priority)
    var filterAiConvo: [Conversation] {
        var filtered = aiConversations

        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { conversation in
                // Search in conversation metadata
                let matchesMetadata = conversation.name.localizedCaseInsensitiveContains(searchText) ||
                    conversation.message.localizedCaseInsensitiveContains(searchText)

                // Also check if conversation ID is in the set of conversations with matching messages
                let matchesMessages = conversationsMatchingSearch.contains(conversation.id)

                return matchesMetadata || matchesMessages
            }
        }

        // Apply button filter
        filtered = applyButtonFilter(to: filtered)

        // Sort by priority
        return filtered.sorted { $0.sortPriority < $1.sortPriority }
    }
    
    // Count of unread conversations
    var unreadCount: Int {
        let humanUnread = humanConversations.filter { $0.unreadCount > 0 }.count
//        let aiUnread = aiConversations.filter { $0.unreadCount > 0 }.count
        return humanUnread
    }
    
    // Count of unresolved conversations
    var unresolvedCount: Int {
        let aiUnresolved = aiConversations.filter { $0.status != .resolved }.count
//        let humanUnresolved = humanConversations.filter {
//            $0.status != .resolved
//        }.count
//        let humanUnresolved1 = unreadCount
        return aiUnresolved + unreadCount
    }
    
    
    // Current user buat satu
    private init() {
        loadConversations()
    }
    
    // MARK: Data Loading
    
    func loadConversations() {
        // Load from dummy data or API
        // Ntar di update
        humanConversations = Conversation.humanDummyData
        aiConversations = Conversation.aiDummyData
    }
    
    
    func selectConversation(_ conversation: Conversation) {
        selectedConversation = conversation
    }
    
    
    // Apply filter from button (All, Unread, Unresolved)
    func applyFilter(_ filter: String) {
        selectedFilter = filter
    }
    
    // Method version of searchConversations - now searches through all messages
    func searchConversations() {
        guard !searchText.isEmpty else {
            conversationsMatchingSearch.removeAll()
            matchingMessagePreviews.removeAll()
            return
        }

        // Search through messages asynchronously
        Task {
            var matchingConversationIds: Set<UUID> = []
            var messagePreviews: [UUID: String] = [:]
            let allConversations = humanConversations + aiConversations

            for conversation in allConversations {
                do {
                    let messages = try await messageService.fetchMessages(conversationId: conversation.id)

                    // Find all matching messages
                    let matchingMessages = messages.filter { message in
                        message.content.localizedCaseInsensitiveContains(searchText)
                    }

                    if !matchingMessages.isEmpty {
                        matchingConversationIds.insert(conversation.id)

                        // Get the most recent matching message (messages are sorted by timestamp)
                        if let mostRecentMatch = matchingMessages.sorted(by: { $0.timestamp > $1.timestamp }).first {
                            messagePreviews[conversation.id] = mostRecentMatch.content
                        }
                    }
                } catch {
                    print("Error searching messages for conversation \(conversation.name): \(error)")
                }
            }

            // Update the published properties on main thread
            await MainActor.run {
                conversationsMatchingSearch = matchingConversationIds
                matchingMessagePreviews = messagePreviews
                print("Found \(matchingConversationIds.count) conversations with messages matching '\(searchText)'")
            }
        }
    }

    // Get preview message for a conversation (matching message when searching, otherwise last message)
    func getPreviewMessage(for conversation: Conversation) -> String {
        if !searchText.isEmpty, let matchingPreview = matchingMessagePreviews[conversation.id] {
            return matchingPreview
        }
        return conversation.message
    }
    
    // Helper to apply button filter
    private func applyButtonFilter(to conversations: [Conversation]) -> [Conversation] {
        switch selectedFilter {
        case "Unread":
            return conversations.filter { $0.unreadCount > 0 }
        case "Unresolved":
            return conversations.filter { conversation in
                if conversation.handlerType == .ai {
                    return conversation.status != .resolved
                }
                return true
            }
        default:
            return conversations
        }
    }
    
    // MARK: TakeOver Functionality
    
    // Takes over an AI conversation and converts it to human-handled
    func takeOverConversation() {
        guard let selected = selectedConversation,
              selected.handlerType == .ai,
              (selected.status == .pending || selected.status == .open) else {
            print("  - handlerType: \(selectedConversation?.handlerType.rawValue ?? "nil")")
            return
        }
        
        print("Take over convo: \(selected.name)")
        
        // Create updated conversation with human handler
        let updatedConversation = Conversation(
            id: selected.id,
            name: selected.name,
            message: selected.message,
            time: getCurrentTime(),
            profileImage: selected.profileImage,
            unreadCount: selected.unreadCount,
            hasWhatsApp: selected.hasWhatsApp,
            phoneNumber: selected.phoneNumber,
            handlerType: .human,  // Changed from .ai to .human
            status: nil,          // Remove AI status
            label: selected.label,
            handledBy: currentUser,  // Assign to current user
            handledAt: getCurrentTime(),
            handledDate: Date(),
            isEvaluated: selected.isEvaluated,
            evaluatedAt: selected.evaluatedAt,
            resolvedAt: selected.resolvedAt,        
            seenBy: [
                SeenByRecord(
                    user: currentUser,
                    seenAt: getCurrentTime()
                )
            ],
            internalNotes: selected.internalNotes
        )
        
        // Remove from AI list
        if let index = aiConversations.firstIndex(where: { $0.id == selected.id }) {
            aiConversations.remove(at: index)
            print("Ai Convo removed :  \(index))")
        }
        
        // Add to human list (at the top)
        humanConversations.insert(updatedConversation, at: 0)
        print("Added to human convo \(humanConversations.count))")
        
        // Update selected conversation
        selectedConversation = updatedConversation
        print("Updated selected conversation")
        
        // Optional: Add internal note about takeover
        addInternalNote(
            to: updatedConversation.id,
            message: "Conversation taken over from AI by \(currentUser.name)"
        )
    }
    
    // MARK: - Resolve Functionality
    
    // Resolves the current conversation
    func resolveConversation() {
        guard let selected = selectedConversation else {
            print("No conversation selected")
            return
        }
        
        if selected.handlerType == .ai {
            // Update AI conversation to resolved
            if let index = aiConversations.firstIndex(where: { $0.id == selected.id }) {
                let updatedConversation = Conversation(
                    id: selected.id,
                    name: selected.name,
                    message: selected.message,
                    time: selected.time,
                    profileImage: selected.profileImage,
                    unreadCount: 0,
                    hasWhatsApp: selected.hasWhatsApp,
                    phoneNumber: selected.phoneNumber,
                    handlerType: selected.handlerType,
                    status: .resolved,  // Update status
                    label: selected.label,
                    handledBy: selected.handledBy,
                    handledAt: selected.handledAt,
                    handledDate: Date(),
                    isEvaluated: false,
                    evaluatedAt: nil,
                    resolvedAt: Date(),                  
                    seenBy: selected.seenBy,
                    internalNotes: selected.internalNotes
                )
                
                aiConversations[index] = updatedConversation
                selectedConversation = updatedConversation
                print("AI conversation resolved: \(selected.name)")
            }
        } else {
            // For human conversations
            if selected.handlerType == .human {
                if let index = humanConversations.firstIndex(where: { $0.id == selected.id }) {
                    let updatedConversation = Conversation(
                        id: selected.id,
                        name: selected.name,
                        message: selected.message,
                        time: selected.time,
                        profileImage: selected.profileImage,
                        unreadCount: 0,
                        hasWhatsApp: selected.hasWhatsApp,
                        phoneNumber: selected.phoneNumber,
                        handlerType: .ai,
                        status: .resolved,  // Update status
                        label: selected.label,
                        handledBy: selected.handledBy,
                        handledAt: selected.handledAt,
                        handledDate: Date(),
                        isEvaluated: false,
                        evaluatedAt: nil,
                        resolvedAt: Date(),
                        seenBy: selected.seenBy,
                        internalNotes: selected.internalNotes
                    )
                    humanConversations[index] = updatedConversation
                    selectedConversation = updatedConversation
                    
                    if let index = humanConversations.firstIndex(where: { $0.id == selected.id}) {
                        humanConversations.remove(at: index)
                        print("Human convo to AI : \(index)")
                    }
                    
                    aiConversations.insert(updatedConversation, at : 0)
                    
                    selectedConversation = updatedConversation
                    print("Updated selected conversation")
                    
                    addInternalNote(
                        to: updatedConversation.id,
                        message: "Conversation marked as resolved by \(currentUser.name)"
                    )
                }
            }
        }
    }
    
    // MARK: - Evaluate Functionality

    // Add conversation to evaluation page
    func evaluateMessage() {
        guard let selected = selectedConversation else {
            print("No conversation selected")
            toastManager.show(.conversationSuccessfullyEvaluated)
            return
        }

        // Check if conversation can be evaluated
        guard selected.canBeEvaluated else {
            print("Conversation cannot be evaluated (must be resolved)")
            toastManager.show(.errorToEvaluateConversation)
            return
        }

        // Add to evaluation list via shared instance
        EvaluationViewModel.shared.addConversation(selected)
        print("Conversation sent to evaluation: \(selected.name)")
        toastManager.show(.successEvaluateConversation)
    }

    // MARK: - Update Conversation

    // Update conversation in the list (for label changes, etc)
    func updateConversation(_ updatedConversation: Conversation) {
        // Update in human conversations
        if let index = humanConversations.firstIndex(where: { $0.id == updatedConversation.id }) {
            humanConversations[index] = updatedConversation
            // Update selected conversation if it's the same one
            if selectedConversation?.id == updatedConversation.id {
                selectedConversation = updatedConversation
            }
            print("Update conversation : \(updatedConversation.name)")
            return
        }

        // Update in AI conversations
        if let index = aiConversations.firstIndex(where: { $0.id == updatedConversation.id }) {
            aiConversations[index] = updatedConversation
            // Update selected conversation if it's the same one
            if selectedConversation?.id == updatedConversation.id {
                selectedConversation = updatedConversation
            }
            print("Update conversation: \(updatedConversation.name)")
            return
        }

        print("Conversation not found: \(updatedConversation.id)")
    }


    // MARK: - Internal Notes
    
    // Adds an internal note to a conversation
    private func addInternalNote(to conversationId: UUID, message: String) {
        let note = InternalNote(
            conversationId: conversationId,
            author: currentUser,
            message: message,
            timestamp: Date()
        )
        
        // Update in human conversations
        if let index = humanConversations.firstIndex(where: { $0.id == conversationId }) {
            humanConversations[index].internalNotes.append(note)
        }
        
        // Update in AI conversations
        if let index = aiConversations.firstIndex(where: { $0.id == conversationId }) {
            aiConversations[index].internalNotes.append(note)
        }
        
        // Update selected conversation
        if selectedConversation?.id == conversationId {
            selectedConversation?.internalNotes.append(note)
        }
    }
    
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return formatter.string(from: Date())
    }
}

