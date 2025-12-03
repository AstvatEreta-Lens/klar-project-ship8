//
//  InternalNotesModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import Foundation

struct InternalNote: Identifiable, Equatable {
    let id: UUID
    let conversationId: UUID
    let author: User
    let message: String
    let timestamp : Date
    
    init(
        id: UUID = UUID(),
        conversationId: UUID,
        author: User,
        message: String,
        timestamp : Date = Date()
    ) {
        self.id = id
        self.conversationId = conversationId
        self.author = author
        self.message = message
        self.timestamp = timestamp
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timestamp)
    }
    
    // Helper method untuk create updated copy
    func updating(message: String) -> InternalNote {
        InternalNote(
            id: self.id,
            conversationId: self.conversationId,
            author: self.author,
            message: message,
            timestamp: Date()
        )
    }
    
    // Equatable conformance
    // noteA == noteB
    // left hand side, right hand side
    static func == (lhs: InternalNote, rhs: InternalNote) -> Bool {
        lhs.id == rhs.id &&
        lhs.conversationId == rhs.conversationId &&
        lhs.author.id == rhs.author.id &&
        lhs.message == rhs.message &&
        lhs.timestamp == rhs.timestamp
    }
}
