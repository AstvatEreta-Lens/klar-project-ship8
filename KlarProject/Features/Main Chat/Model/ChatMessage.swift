//
//  MessageStatus.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 21/11/25.
//
import Foundation
import SwiftUI


// MARK: - Chat Message Model
struct ChatMessage: Identifiable, Equatable {
    let id: String
    let text: String
    let isFromUser: Bool
    let timestamp: Date
    let messageId: String?
    var status: MessageStatus
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id &&
               lhs.status == rhs.status &&
               lhs.text == rhs.text &&
               lhs.timestamp == rhs.timestamp
    }
}
// MARK: - Message Status Enum
enum MessageStatus: String, Codable {
    case sending = "sending"
    case sent = "sent"
    case delivered = "delivered"
    case read = "read"
    case failed = "failed"
    
    var iconName: String {
        switch self {
        case .sending: return "clock"
        case .sent: return "checkmark"
        case .delivered: return "checkmark.circle"
        case .read: return "checkmark.circle.fill"
        case .failed: return "exclamationmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .read: return .blue
        case .failed: return .red
        case .sending: return .gray.opacity(0.5)
        default: return .gray
        }
    }
}
