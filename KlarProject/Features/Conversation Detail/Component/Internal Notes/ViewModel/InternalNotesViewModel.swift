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
    @Published var editingNote: InternalNote? = nil
    
    private let conversationId: UUID
    private let currentUser: User
    private let service: InternalNotesServiceProtocol
    
    var isEditMode: Bool {
        editingNote != nil
    }
    
    init(
        conversationId: UUID,
        currentUser: User,
        service: InternalNotesServiceProtocol = MockInternalNotesService.shared
    ) {
        self.conversationId = conversationId
        self.currentUser = currentUser
        self.service = service
        
        print("InternalNotesViewModel initialized for conversation: \(conversationId)")
        
        // Load notes on init
        Task {
            await loadNotes()
        }
    }
    
    func sendNote(message: String) {
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // Check if we're in edit mode
        if let editingNote = editingNote {
            updateNote(editingNote, with: trimmed)
            self.editingNote = nil
        } else {
            // Create new note
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
    }
    
    func startEditingNote(_ note: InternalNote) {
        editingNote = note
        print("Editing note: \(note.message)")
    }
    
    func cancelEditing() {
        editingNote = nil
        print("Editing cancelled")
    }
    
    private func updateNote(_ note: InternalNote, with newMessage: String) {
        let updatedNote = note.updating(message: newMessage)
        
        // Optimistic update
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = updatedNote
        }
        
        // Update in background
        Task {
            do {
                try await service.updateNote(updatedNote)
                print("Note updated successfully")
            } catch {
                // Rollback on error
                if let index = notes.firstIndex(where: { $0.id == updatedNote.id }) {
                    notes[index] = note // Restore original
                }
                errorMessage = "Failed to update note: \(error.localizedDescription)"
            }
        }
    }
    
    func loadNotes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            notes = try await service.fetchNotes(conversationId: conversationId)
            isLoading = false
            print("Loaded \(notes.count) notes")
        } catch {
            errorMessage = "Failed to load notes: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func deleteNote(_ note: InternalNote) {
        // Cancel editing if we're deleting the note being edited
        if editingNote?.id == note.id {
            editingNote = nil
        }
        
        // Optimistic delete
        notes.removeAll { $0.id == note.id }
        
        // Delete in background
        Task {
            do {
                try await service.deleteNote(id: note.id)
                print("Note deleted successfully")
            } catch {
                // Rollback on error
                notes.append(note)
                notes.sort { $0.timestamp < $1.timestamp }
                errorMessage = "Failed to delete note: \(error.localizedDescription)"
            }
        }
    }
}
