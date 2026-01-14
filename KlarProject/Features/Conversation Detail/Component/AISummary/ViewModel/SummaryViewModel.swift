//
//  SummaryModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import Foundation
import Combine

@MainActor
class AISummaryViewModel: ObservableObject {
    @Published var summary: AISummary?
    @Published var isLoading: Bool = false
    @Published var isGenerating: Bool = false
    @Published var errorMessage: String?
    
    private let conversationId: UUID
    private let service: AISummaryServiceProtocol
    
    init(
        conversationId: UUID,
        service: AISummaryServiceProtocol = MockAISummaryService.shared //Ganti dengan yang asli ntar
    ) {
        self.conversationId = conversationId
        self.service = service
        
        // Load existing summary on init
        Task {
            await loadSummary()
        }
    }
    
    // Load existing summary if available
    func loadSummary() async {
        isLoading = true
        errorMessage = nil
        
        do {
            summary = try await service.fetchSummary(conversationId: conversationId)
            isLoading = false
        } catch {
            errorMessage = "Failed to load summary: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // Generate new summary from messages
    func generateSummary(from messages: [Message]) async {
        guard !messages.isEmpty else {
            errorMessage = "No messages to summarize"
            return
        }
        
        isGenerating = true
        errorMessage = nil
        
        do {
            let newSummary = try await service.generateSummary(
                conversationId: conversationId,
                messages: messages
            )
            
            summary = newSummary
            isGenerating = false
            
            print("Summary generated successfully")
        } catch {
            errorMessage = "Failed to generate summary: \(error.localizedDescription)"
            isGenerating = false
        }
    }
    
    // Regenerate summary (e.g., when conversation has new messages)
    func regenerateSummary(from messages: [Message]) async {
        isGenerating = true
        errorMessage = nil
        
        do {
            let newSummary = try await service.regenerateSummary(
                conversationId: conversationId,
                messages: messages
            )
            
            summary = newSummary
            isGenerating = false
            
            print("Summary regenerated successfully")
        } catch {
            errorMessage = "Failed to regenerate summary: \(error.localizedDescription)"
            isGenerating = false
        }
    }
    
    // Delete summary
    func deleteSummary() async {
        guard summary != nil else { return }
        
        let previousSummary = summary
        summary = nil // Optimistic delete
        
        do {
            try await service.deleteSummary(conversationId: conversationId)
            print("Summary deleted")
        } catch {
            summary = previousSummary // Rollback
            errorMessage = "Failed to delete summary: \(error.localizedDescription)"
        }
    }
    
    // Check if summary needs update (based on message count)
    func needsUpdate(currentMessageCount: Int) -> Bool {
        guard let summary = summary else { return true }
        return currentMessageCount > summary.messageCount
    }
}
