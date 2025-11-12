//
//  Conversation.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/10/25.
//




// Models.swift
import Foundation
import SwiftUI
import Combine


// MARK: - User Models
struct User: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let profileImage: String
    let email: String
    
    init(id: UUID = UUID(), name: String, profileImage: String, email: String = "") {
        self.id = id
        self.name = name
        self.profileImage = profileImage
        self.email = email
    }
}

struct SeenByRecord: Identifiable, Codable {
    let id: UUID
    let user: User
    let seenAt: String
    
    init(id: UUID = UUID(), user: User, seenAt: String) {
        self.id = id
        self.user = user
        self.seenAt = seenAt
    }
}


// MARK: - Conversation Model
struct Conversation: Identifiable, Codable {
    let id: UUID
    let name: String
    var message: String
    var time: String
    let profileImage: String
    var unreadCount: Int
    let hasWhatsApp: Bool
    let phoneNumber: String
    
    var handlerType: HandlerType
    var status: statusType?
    var label: [LabelType]
    
    var handledBy: User?
    var handledAt: String?
    
    var seenBy: [SeenByRecord]
    var internalNotes: [InternalNote]
    var messages: [Message]
    
    init(
        id: UUID = UUID(),
        name: String,
        message: String = "",
        time: String = "",
        profileImage: String = "",
        unreadCount: Int = 0,
        hasWhatsApp: Bool = true,
        phoneNumber: String,
        handlerType: HandlerType = .ai,
        status: statusType? = .pending,
        label: [LabelType] = [],
        handledBy: User? = nil,
        handledAt: String? = nil,
        seenBy: [SeenByRecord] = [],
        internalNotes: [InternalNote] = [],
        messages: [Message] = []
    ) {
        self.id = id
        self.name = name
        self.message = message
        self.time = time
        self.profileImage = profileImage
        self.unreadCount = unreadCount
        self.hasWhatsApp = hasWhatsApp
        self.phoneNumber = phoneNumber
        self.handlerType = handlerType
        self.status = status
        self.label = label
        self.handledBy = handledBy
        self.handledAt = handledAt
        self.seenBy = seenBy
        self.internalNotes = internalNotes
        self.messages = messages
    }
    
    var timeInMinutes: Int {
        let components = time.split(separator: ".")
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return 0
        }
        return hours * 60 + minutes
    }
    
    var sortPriority: Int {
        guard let status = status else {
            return 999
        }
        
        switch status {
        case .pending: return 1
        case .open: return 2
        case .resolved: return 3
        }
    }
    
    mutating func addMessage(_ message: Message) {
        messages.append(message)
        self.message = message.content
        self.time = message.timeString
        if message.isFromUser {
            self.unreadCount += 1
        }
    }
    
    mutating func markAsRead() {
        self.unreadCount = 0
    }
}

// MARK: - Enums
enum HandlerType: String, Codable {
    case human
    case ai
}



