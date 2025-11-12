//
//  SendMessageResponse.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 06/11/25.
//


import Foundation

struct SendMessageResponse: Codable {
    let success: Bool
    let messageId: String?
    let error: String?
}

struct ConversationsResponse: Codable {
    let conversations: [ConversationData]?
}

struct ConversationData: Codable {
    let phoneNumber: String
    let name: String?
    let lastMessage: String?
    let timestamp: String?
}

struct MessagesResponse: Codable {
    let messages: [APIMessageData]?
}

struct APIMessageData: Codable {
    let id: String
    let from: String
    let text: String
    let timestamp: String
    let type: String
}
