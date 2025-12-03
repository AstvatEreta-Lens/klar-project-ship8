//
//  Conversation.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/10/25.
//

import Foundation

// MARK: - Supporting Models

struct User: Identifiable {
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

struct SeenByRecord: Identifiable {
    let id: UUID
    let user: User
    let seenAt: String
    
    init(id: UUID = UUID(), user: User, seenAt: String) {
        self.id = id
        self.user = user
        self.seenAt = seenAt
    }
}

// MARK: - Main Model

struct Conversation: Identifiable {
    // Basic Info
    let id: UUID
    let name: String
    let message: String
    let time: String
    let profileImage: String
    let unreadCount: Int
    let hasWhatsApp: Bool
    let phoneNumber: String
    
    // Conversation Properties
    let handlerType: HandlerType
    let status: statusType?
    let label: [LabelType]
    
    // Handler Info
    let handledBy: User
    let handledAt: String
    let handledDate: Date
    
    var isEvaluated: Bool
    var evaluatedAt: Date?
    var resolvedAt: Date?
    
    // Collaboration Info
    var seenBy: [SeenByRecord]
    
    // Internal Notes
    var internalNotes: [InternalNote]
    
    // MARK: - Computed Properties
    
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
            return Int.max
        }
        switch status {
        case .pending: return 1   // Highest priority
        case .open: return 2
        case .resolved: return 3  // Lowest priority
        }
    }
    
    var canBeEvaluated: Bool {
        return status == .resolved
    }
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        name: String,
        message: String,
        time: String,
        profileImage: String,
        unreadCount: Int,
        hasWhatsApp: Bool,
        phoneNumber: String,
        handlerType: HandlerType,
        status: statusType?,
        label: [LabelType] = [],
        handledBy: User,
        handledAt: String,
        handledDate: Date = Date(),
        isEvaluated: Bool = false,
        evaluatedAt: Date? = nil,
        resolvedAt: Date? = nil,
        seenBy: [SeenByRecord] = [],
        internalNotes: [InternalNote] = []
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
        self.handledDate = handledDate
        self.isEvaluated = isEvaluated
        self.evaluatedAt = evaluatedAt
        self.resolvedAt = resolvedAt
        self.seenBy = seenBy
        self.internalNotes = internalNotes
    }
    
    func withEvaluationStatus(isEvaluated: Bool) -> Conversation {
        return Conversation(
            id: self.id,
            name: self.name,
            message: self.message,
            time: self.time,
            profileImage: self.profileImage,
            unreadCount: self.unreadCount,
            hasWhatsApp: self.hasWhatsApp,
            phoneNumber: self.phoneNumber,
            handlerType: self.handlerType,
            status: self.status,
            label: self.label,
            handledBy: self.handledBy,
            handledAt: self.handledAt,
            handledDate: self.handledDate,
            isEvaluated: isEvaluated,
            evaluatedAt: isEvaluated ? Date() : self.evaluatedAt,
            resolvedAt: self.resolvedAt,
            seenBy: self.seenBy,
            internalNotes: self.internalNotes
        )
    }
}


// MARK: - Enums

enum HandlerType: String, Codable {
    case human
    case ai
}

