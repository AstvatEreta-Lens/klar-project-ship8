//
//  EvaluationViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 11/11/25.
//

import SwiftUI
import Combine

@MainActor
class EvaluationViewModel: ObservableObject {

    // Singleton instance untuk share state across the app
    static let shared = EvaluationViewModel()

    @Published var selectedConversation: Conversation?
    @Published var evaluatedConversations: [Conversation] = []
    @Published var unevaluatedConversations: [Conversation] = []
    @Published var searchText: String = ""


    var allConversations: [Conversation] {
        return evaluatedConversations + unevaluatedConversations
    }

    var evaluatedCount: Int {
        return evaluatedConversations.count
    }

    var unevaluatedCount: Int {
        return unevaluatedConversations.count
    }


    init() {
        // Load dummy data hanya untuk testing - nanti akan dihapus
        loadDummyDataForTesting()
    }

    // MARK: - Load dummy data for testing only
    private func loadDummyDataForTesting() {
        // Hanya load yang sudah isEvaluated = true untuk testing
        let testEvaluated = Conversation.aiDummyData.filter { $0.isEvaluated == true }
        evaluatedConversations = testEvaluated
            .sorted { ($0.evaluatedAt ?? Date()) > ($1.evaluatedAt ?? Date()) }

        // Unevaluated akan diisi melalui addConversation() dari button Evaluate
        unevaluatedConversations = []
    }

    // MARK: - Add Conversation to Evaluation

    // Add a conversation to the evaluation list (called when "Evaluate this conversation" is clicked)
    func addConversation(_ conversation: Conversation) {
        // Check if conversation is already in the list
        let alreadyInUnevaluated = unevaluatedConversations.contains(where: { $0.id == conversation.id })
        let alreadyInEvaluated = evaluatedConversations.contains(where: { $0.id == conversation.id })

        if alreadyInUnevaluated || alreadyInEvaluated {
            print("Conversation already in evaluation list")
            return
        }

        // Add to unevaluated list
        unevaluatedConversations.insert(conversation, at: 0)
        print("Added conversation to evaluation: \(conversation.name)")
    }
    
    
    func selectConversation(_ conversation: Conversation) {
        selectedConversation = conversation
        print("conversation: \(conversation.name)")
    }
    
    func deselectConversation() {
        selectedConversation = nil
    }
    
    
    func approveConversation(_ conversation: Conversation) {
        // Find in unevaluated list
        guard let index = unevaluatedConversations.firstIndex(where: { $0.id == conversation.id }) else {
            print("Conversation not found in unevaluated list")
            return
        }

        // Update conversation with evaluated status
        var updatedConversation = unevaluatedConversations[index]
        updatedConversation.isEvaluated = true
        updatedConversation.evaluatedAt = Date()

        // Remove from unevaluated
        unevaluatedConversations.remove(at: index)

        // Add to evaluated (at the top)
        evaluatedConversations.insert(updatedConversation, at: 0)

        // Deselect conversation so card shows evaluated state (not selected)
        selectedConversation = nil

        print("Conversation approved: \(conversation.name)")
    }
    
    // MARK: - Remove Functionality
    
    // Remove conversation from evaluation lists
    func removeConversation(_ conversation: Conversation) {
        var removed = false
        
        // Try to remove from unevaluated list
        if let index = unevaluatedConversations.firstIndex(where: { $0.id == conversation.id }) {
            unevaluatedConversations.remove(at: index)
            removed = true
            print("Removed from unevaluated list: \(conversation.name)")
        }
        
        // Try to remove from evaluated list
        if let index = evaluatedConversations.firstIndex(where: { $0.id == conversation.id }) {
            evaluatedConversations.remove(at: index)
            removed = true
            print("Removed from evaluated list: \(conversation.name)")
        }
        
        // Deselect if it was the selected conversation
        if selectedConversation?.id == conversation.id {
            selectedConversation = nil
            print("  - Deselected conversation")
        }
        
        if removed {
            print("Conversation dihapus")
        } else {
            print("Conversation gaada di list")
        }
    }
    
    
    func searchConversations(in list: [Conversation]) -> [Conversation] {
        if searchText.isEmpty {
            return list
        }
        
        return list.filter { conversation in
            conversation.name.localizedCaseInsensitiveContains(searchText) ||
            conversation.message.localizedCaseInsensitiveContains(searchText) ||
            conversation.phoneNumber.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    // Get card state for a conversation
    func getCardState(for conversation: Conversation) -> CardStateColor {
        if selectedConversation?.id == conversation.id {
            return .selected
        }
        return conversation.isEvaluated ? .evaluated : .unevaluated
    }
    
    // Check if conversation can be approved (must be unevaluated)
    func canApprove(_ conversation: Conversation) -> Bool {
        return !conversation.isEvaluated && conversation.status == .resolved
    }
    
    // Format date for display
    func formatResolvedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
    
    // Format time for display
    func formatResolvedTime(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
