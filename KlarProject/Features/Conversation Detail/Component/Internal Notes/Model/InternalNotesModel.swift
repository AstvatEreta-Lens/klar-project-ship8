//
//  InternalNotesModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import Foundation

struct InternalNote: Identifiable {
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
}
