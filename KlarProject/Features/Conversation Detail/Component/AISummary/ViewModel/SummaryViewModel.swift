//
//  SummaryModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import Foundation
import SwiftUI

@MainActor
class AISummaryViewModel: ObservableObject {
    @Published var summary: AISummary?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let conversationId: UUID
    private let apiService = APIService.shared
    
    init(conversationId: UUID) {
        self.conversationId = conversationId
    }
    
    // MARK: - Generate Summary
    func generateSummary(from messages: [ChatMessage]) async {
        guard !messages.isEmpty else {
            errorMessage = "No messages to summarize yet"
            return
        }
        
        // Get phone number from conversation
        guard let phoneNumber = getPhoneNumber(from: messages) else {
            errorMessage = "Unable to identify conversation"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            print("📊 [SUMMARY] Generating summary for conversation: \(conversationId)")
            print("📊 [SUMMARY] Phone number: \(phoneNumber)")
            print("📊 [SUMMARY] Message count: \(messages.count)")
            
            let summaryResponse = try await apiService.generateSummary(phoneNumber: phoneNumber)
            summary = AISummary(from: summaryResponse)
            
            print("✅ [SUMMARY] Summary generated successfully")
            
        } catch {
            print("❌ [SUMMARY] Error: \(error.localizedDescription)")
            errorMessage = "Failed to generate summary. Please try again."
        }
        
        isLoading = false
    }
    
    // MARK: - Regenerate Summary
    func regenerateSummary(from messages: [ChatMessage]) async {
        print("🔄 [SUMMARY] Regenerating summary...")
        await generateSummary(from: messages)
    }
    
    // MARK: - Delete Summary
    func deleteSummary() async {
        guard let currentSummary = summary else {
            print("⚠️ [SUMMARY] No summary to delete")
            return
        }
        
        do {
            print("🗑️  [SUMMARY] Deleting summary for session: \(currentSummary.sessionId)")
            
            try await apiService.deleteSummary(sessionId: currentSummary.sessionId)
            summary = nil
            
            print("✅ [SUMMARY] Summary deleted successfully")
            
        } catch {
            print("❌ [SUMMARY] Delete error: \(error.localizedDescription)")
            errorMessage = "Failed to delete summary"
        }
    }
    
    // MARK: - Check if Update Needed
    func needsUpdate(currentMessageCount: Int) -> Bool {
        guard let summary = summary else { return false }
        return currentMessageCount > summary.messageCount
    }
    
    // MARK: - Helper Functions
    private func getPhoneNumber(from messages: [ChatMessage]) -> String? {
        // Get phone number from ConversationListViewModel
        // We need to match conversationId to get phone number
        let conversationViewModel = ConversationListViewModel.shared
        
        // Find conversation by ID
        let allConversations = conversationViewModel.aiConversations + conversationViewModel.humanConversations
        let conversation = allConversations.first { $0.id == conversationId }
        
        return conversation?.phoneNumber
    }
}
