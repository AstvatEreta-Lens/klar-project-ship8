//
//  InternalNotesViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import Foundation
import Combine

@MainActor
class InternalNotesViewModel: ObservableObject {
    @Published var notes: [InternalNote] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let conversationId: UUID
    private let currentUser: User
    private let service: InternalNotesServiceProtocol
    
    init(
        conversationId: UUID,
        currentUser: User,
        service: InternalNotesServiceProtocol = MockInternalNotesService.shared
    ) {
        self.conversationId = conversationId
        self.currentUser = currentUser
        self.service = service
        
        print("\(conversationId)")
        
        // Load notes on init
        Task {
            await loadNotes()
        }
    }
    
    func sendNote(message: String) {
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let newNote = InternalNote(
            conversationId: conversationId,
            author: currentUser,
            message: trimmed
        )
        
        // Optimistic update (add to UI immediately)
        notes.append(newNote)
        
        // Save in background
        Task {
            do {
                try await service.saveNote(newNote)
                print("Note sent successfully")
            } catch {
                // Rollback on error
                notes.removeAll { $0.id == newNote.id }
                errorMessage = "Failed to send note: \(error.localizedDescription)"
            }
        }
    }
    
    func loadNotes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            notes = try await service.fetchNotes(conversationId: conversationId)
            isLoading = false
        } catch {
            errorMessage = "Failed to load notes: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func deleteNote(id: UUID) {
        // Optimistic delete
        let deletedNote = notes.first { $0.id == id }
        notes.removeAll { $0.id == id }
        
        // Delete in background
        Task {
            do {
                try await service.deleteNote(id: id)
            } catch {
                // Rollback on error
                if let note = deletedNote {
                    notes.append(note)
                    errorMessage = "Failed to delete note"
                }
            }
        }
    }
}
