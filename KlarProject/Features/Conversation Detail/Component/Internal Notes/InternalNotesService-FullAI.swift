//
//  InternalNotesService.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//
import Foundation

protocol InternalNotesServiceProtocol {
    func fetchNotes(conversationId: UUID) async throws -> [InternalNote]
    func saveNote(_ note: InternalNote) async throws
    func updateNote(_ note: InternalNote) async throws  // NEW: Added for edit functionality
    func deleteNote(id: UUID) async throws
}

// MARK: - Mock Service with Per-Conversation Storage
class MockInternalNotesService: InternalNotesServiceProtocol {
    // Storage: [ConversationID: [Notes]]
    private var storage: [UUID: [InternalNote]] = [:]
    
    // Shared instance for persistence across views
    static let shared = MockInternalNotesService()
    
    private init() {
        // Pre-populate with dummy data from Conversation model
        populateFromDummyData()
    }
    
    private func populateFromDummyData() {
        // Load dummy data from Conversation.humanDummyData
        for conversation in Conversation.humanDummyData {
            if !conversation.internalNotes.isEmpty {
                storage[conversation.id] = conversation.internalNotes
            }
        }
    }
    
    func fetchNotes(conversationId: UUID) async throws -> [InternalNote] {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        // Return notes for this specific conversation
        return storage[conversationId] ?? []
    }
    
    func saveNote(_ note: InternalNote) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        
        if storage[note.conversationId] != nil {
            storage[note.conversationId]?.append(note)
        } else {
            storage[note.conversationId] = [note]
        }
        
        print("Note saved for conversation: \(note.conversationId)")
        print(" Total notes for this conversation: \(storage[note.conversationId]?.count ?? 0)")
    }
    
    // NEW: Update existing note
    func updateNote(_ note: InternalNote) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        
        guard var notes = storage[note.conversationId] else {
            throw NSError(domain: "InternalNotesService", code: 404,
                         userInfo: [NSLocalizedDescriptionKey: "Conversation not found"])
        }
        
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            storage[note.conversationId] = notes
            print("Note updated for conversation: \(note.conversationId)")
            print("Updated message: \(note.message)")
        } else {
            throw NSError(domain: "InternalNotesService", code: 404,
                         userInfo: [NSLocalizedDescriptionKey: "Note not found"])
        }
    }
    
    func deleteNote(id: UUID) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        
        for (conversationId, notes) in storage {
            if let index = notes.firstIndex(where: { $0.id == id }) {
                storage[conversationId]?.remove(at: index)
                print("Note deleted from conversation: \(conversationId)")
                return
            }
        }
    }
}


// MARK: - Real API Service (not implemented yet)
class APIInternalNotesService: InternalNotesServiceProtocol {
    private let baseURL = "https://api.yourapp.com" // Replace with actual API
    
    func fetchNotes(conversationId: UUID) async throws -> [InternalNote] {
        // TODO: Implement real API call
        // let url = URL(string: "\(baseURL)/conversations/\(conversationId)/notes")!
        // let (data, _) = try await URLSession.shared.data(from: url)
        // return try JSONDecoder().decode([InternalNote].self, from: data)
        
        fatalError("API not implemented yet - use MockInternalNotesService")
    }
    
    func saveNote(_ note: InternalNote) async throws {
        // TODO: Implement real API call
        fatalError("API not implemented yet - use MockInternalNotesService")
    }
    
    // NEW: Update note via API
    func updateNote(_ note: InternalNote) async throws {
        // TODO: Implement real API call
        // let url = URL(string: "\(baseURL)/notes/\(note.id)")!
        // var request = URLRequest(url: url)
        // request.httpMethod = "PUT"
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.httpBody = try JSONEncoder().encode(note)
        // let (_, _) = try await URLSession.shared.data(for: request)
        
        fatalError("API not implemented yet - use MockInternalNotesService")
    }
    
    func deleteNote(id: UUID) async throws {
        // TODO: Implement real API call
        fatalError("API not implemented yet - use MockInternalNotesService")
    }
}
