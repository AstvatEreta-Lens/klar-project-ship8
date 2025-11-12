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
    // MARK: - Published Properties
    
    @Published var selectedConversation: Conversation?
    @Published var humanConversations: [Conversation] = []
    @Published var aiConversations: [Conversation] = []
    @Published var searchText: String = ""
    @Published var selectedFilter: String = "All" // Added for filter buttons
    
    // MARK: - Computed Properties for Filtering
    
    // Filtered human conversations (by search text)
    var filterHumanConvo: [Conversation] {
        var filtered = humanConversations
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { conversation in
                conversation.name.localizedCaseInsensitiveContains(searchText) ||
                conversation.message.localizedCaseInsensitiveContains(searchText)
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
                conversation.name.localizedCaseInsensitiveContains(searchText) ||
                conversation.message.localizedCaseInsensitiveContains(searchText)
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
    private var currentUser: User = User(
        name: "Current User",
        profileImage: "user-avatar",
        email: "user@example.com"
    )
    
    
    init() {
        loadConversations()
    }
    
    // MARK: - Data Loading
    
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
    
    // Method version of searchConversations
    func searchConversations() -> [Conversation] {
        let allConversations = humanConversations + aiConversations
        if searchText.isEmpty {
            return allConversations
        }
        return allConversations.filter { conversation in
            conversation.name.localizedCaseInsensitiveContains(searchText) ||
            conversation.message.localizedCaseInsensitiveContains(searchText)
        }
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
    
    // MARK: - TakeOver Functionality
    
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
                        handlerType: selected.handlerType,
                        status: .resolved,  // Update status
                        label: selected.label,
                        handledBy: selected.handledBy,
                        handledAt: selected.handledAt,
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
    
    // MARK: Evaluate Functionality
    func evaluateMessage(){
        // add ke evaluation
        // evaluate pakai AI (panggil AI SUmmary service lagi)
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
