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
        loadEvaluationConversations()
    }
    
    
    func loadEvaluationConversations() {
        // sementara dumy data
        let allResolved = Conversation.aiDummyData.filter { $0.status == .resolved }
        
        // Separate by evaluation status
        evaluatedConversations = allResolved.filter { $0.isEvaluated == true }
            .sorted { ($0.evaluatedAt ?? Date()) > ($1.evaluatedAt ?? Date()) }
        
        unevaluatedConversations = allResolved.filter { $0.isEvaluated != true }
            .sorted { ($0.resolvedAt ?? Date()) > ($1.resolvedAt ?? Date()) }
        
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
        
        // Update selected conversation
        selectedConversation = updatedConversation
        
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
