//
//  SendMessageResponse.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/11/25.
//


// MARK: - API Response Models
struct SendMessageResponse: Codable {
    let success: Bool
    let messageId: String?
    let message: APIMessageData?
    let error: String?
}

struct APIMessageData: Codable {
    let messageId: String?
    let to: String?
    let from: String?
    let text: String?
    let timestamp: String
    let status: String?
    let isFromMe: Bool
    let type: String?
    
    init(messageId: String? = nil, to: String? = nil, from: String? = nil, text: String? = nil, timestamp: String, status: String? = nil, isFromMe: Bool = false, type: String? = nil) {
        self.messageId = messageId
        self.to = to
        self.from = from
        self.text = text
        self.timestamp = timestamp
        self.status = status
        self.isFromMe = isFromMe
        self.type = type
    }
}

struct ConversationsResponse: Codable {
    let success: Bool
    let conversations: [ConversationData]?
}

struct ConversationData: Codable {
    let phoneNumber: String
    let lastMessage: String
    let timestamp: String
    let unreadCount: Int
    let messageCount: Int
}

struct MessagesResponse: Codable {
    let success: Bool
    let phoneNumber: String?
    let messages: [APIMessageData]?
}
