//
//  Message.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 06/11/25.
//


import Foundation
// MARK: - Message Models
struct Message: Identifiable, Codable, Equatable {
    let id: UUID
    let whatsappMessageId: String?
    let conversationId: UUID
    let phoneNumber: String
    let content: String
    let timestamp: Date
    let isFromUser: Bool
    let status: MessageStatus
    let type: MessageType
    
    init(
        id: UUID = UUID(),
        whatsappMessageId: String? = nil,
        conversationId: UUID,
        phoneNumber: String,
        content: String,
        timestamp: Date = Date(),
        isFromUser: Bool,
        status: MessageStatus = .sent,
        type: MessageType = .text
    ) {
        self.id = id
        self.whatsappMessageId = whatsappMessageId
        self.conversationId = conversationId
        self.phoneNumber = phoneNumber
        self.content = content
        self.timestamp = timestamp
        self.isFromUser = isFromUser
        self.status = status
        self.type = type
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timestamp)
    }
}

enum MessageStatus: String, Codable {
    case sending
    case sent
    case delivered
    case read
    case failed
}

enum MessageType: String, Codable {
    case text
    case image
    case document
    case audio
    case video
}
