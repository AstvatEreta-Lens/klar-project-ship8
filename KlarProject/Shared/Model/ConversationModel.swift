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
    
    // Collaboration Info
    var seenBy: [SeenByRecord]
//    var collaborators: [User]
    
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
            return 999 // Human conversations (no status)
        }
        
        switch status {
        case .pending: return 1   // Highest priority
        case .open: return 2
        case .resolved: return 3  // Lowest priority
        }
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
        seenBy: [SeenByRecord] = [],
//        collaborators: [User] = [],
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
        self.seenBy = seenBy
//        self.collaborators = collaborators
        self.internalNotes = internalNotes
    }
}

// MARK: - Enums

enum HandlerType: String, Codable {
    case human
    case ai
}

// MARK: - Dummy Data

extension Conversation {
    static let humanDummyData: [Conversation] = [
        Conversation(
            name: "Lil Bahlil",
            message: "Woy min, alat gw rusak nih!",
            time: "14.29",
            profileImage: "Photo Profile",
            unreadCount: 1,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil,
            label: [.service, .warranty],
            handledBy: User(name: "Ninda", profileImage: "Photo Profile", email: "ninda@example.com"),
            handledAt: "14.29",
            seenBy: [
                SeenByRecord(
                    user: User(name: "Ninda", profileImage: "Photo Profile", email: "ninda@example.com"),
                    seenAt: "14.29"
                )
            ],
//            collaborators: [
//                User(name: "Ninda", profileImage: "Photo Profile", email: "ninda@example.com"),
//                User(name: "John", profileImage: "Photo Profile", email: "john@example.com"),
//                User(name: "Sarah", profileImage: "Photo Profile", email: "sarah@example.com")
//            ],
            internalNotes: [
                InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Ninda Sari", profileImage: "", email: "ninda@example.com"),
                    message: "Customer mengeluh mesin mati mendadak",
                    timestamp: Date().addingTimeInterval(-7200)
                ),
                InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Tech Support", profileImage: "", email: "tech@example.com"),
                    message: "Sudah cek, kayaknya masalah di motherboard",
                    timestamp: Date().addingTimeInterval(-7100)
                )
            ]
        ),
        
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "01.50",
            profileImage: "Photo Profile",
            unreadCount: 3,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil,
            label: [],
            handledBy: User(name: "Photo Profile", profileImage: "Photo Profile", email: "admin@example.com"),
            handledAt: "01.50",
            seenBy: [
                SeenByRecord(
                    user: User(name: "Photo Profile", profileImage: "Photo Profile", email: "admin@example.com"),
                    seenAt: "01.50"
                )
            ],
//            collaborators: [
//                User(name: "Photo Profile", profileImage: "Photo Profile", email: "user@example.com")
//            ],
            internalNotes: [
                InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Indri", profileImage: "", email: "indri@example.com"),
                    message: "Konsumen tadi minta service mesin karena kerusakan kabel",
                    timestamp: Date().addingTimeInterval(-3600)
                ),
                InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Indri", profileImage: "", email: "indri@example.com"),
                    message: "tapi karena ini temen deket ko Alek jadi kasih diskon 30% ya",
                    timestamp: Date().addingTimeInterval(-3500)
                ),
                InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Ahmad", profileImage: "", email: "ahmad@example.com"),
                    message: "Oke noted, nanti saya proses dengan diskon 30%",
                    timestamp: Date().addingTimeInterval(-3400)
                )
            ]
        ),
        
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "01.50",
            profileImage: "Photo Profile",
            unreadCount: 3,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil,
            label: [.spareparts, .service],
            handledBy: User(name: "Admin", profileImage: "Photo Profile", email: "admin@example.com"),
            handledAt: "01.50",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "21.50",
            profileImage: "Photo Profile",
            unreadCount: 3,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil,
            label: [.payment],
            handledBy: User(name: "Finance Team", profileImage: "Photo Profile", email: "finance@example.com"),
            handledAt: "21.50",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "11.50",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil,
            label: [.maintenance],
            handledBy: User(name: "Tech Support", profileImage: "Photo Profile", email: "tech@example.com"),
            handledAt: "11.50",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "11.50",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil,
            label: [],
            handledBy: User(name: "Tech Support", profileImage: "Photo Profile", email: "tech@example.com"),
            handledAt: "11.50",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "11.50",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil,
            label: [],
            handledBy: User(name: "Tech Support", profileImage: "Photo Profile", email: "tech@example.com"),
            handledAt: "11.50",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "11.50",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil,
            label: [.maintenance],
            handledBy: User(name: "Tech Support", profileImage: "Photo Profile", email: "tech@example.com"),
            handledAt: "11.50",
            seenBy: [],
//            collaborators: []
        )
    ]
    
    static let aiDummyData: [Conversation] = [
        Conversation(
            name: "Customer A",
            message: "AI: Urgent!",
            time: "15.30",
            profileImage: "Photo Profile",
            unreadCount: 2,
            hasWhatsApp: true,
            phoneNumber: "+61-1111-1111",
            handlerType: .ai,
            status: .pending,
            label: [],
            handledBy: User(name: "AI Assistant", profileImage: "ai-avatar", email: "ai@example.com"),
            handledAt: "15.30",
            seenBy: [
                SeenByRecord(
                    user: User(name: "AI Assistant", profileImage: "ai-avatar", email: "ai@example.com"),
                    seenAt: "15.30"
                )
            ],
//            collaborators: []
        ),
        
        Conversation(
            name: "Customer B",
            message: "AI: Need help",
            time: "08.20",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-2222-2222",
            handlerType: .ai,
            status: .pending,
            label: [],
            handledBy: User(name: "AI Assistant", profileImage: "ai-avatar", email: "ai@example.com"),
            handledAt: "08.20",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Customer C",
            message: "AI: Working on it",
            time: "12.00",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-3333-3333",
            handlerType: .ai,
            status: .open,
            label: [],
            handledBy: User(name: "AI Assistant", profileImage: "ai-avatar", email: "ai@example.com"),
            handledAt: "12.00",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Customer D",
            message: "AI: In progress",
            time: "06.15",
            profileImage: "Photo Profile",
            unreadCount: 1,
            hasWhatsApp: true,
            phoneNumber: "+61-4444-4444",
            handlerType: .ai,
            status: .open,
            label: [.spareparts],
            handledBy: User(name: "AI Assistant", profileImage: "ai-avatar", email: "ai@example.com"),
            handledAt: "06.15",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Customer E",
            message: "AI: All done!",
            time: "16.45",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-5555-5555",
            handlerType: .ai,
            status: .resolved,
            label: [.maintenance],
            handledBy: User(name: "AI Assistant", profileImage: "ai-avatar", email: "ai@example.com"),
            handledAt: "16.45",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Customer F",
            message: "AI: Completed",
            time: "02.30",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-6666-6666",
            handlerType: .ai,
            status: .resolved,
            label: [],
            handledBy: User(name: "AI Assistant", profileImage: "ai-avatar", email: "ai@example.com"),
            handledAt: "02.30",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Customer B",
            message: "AI: Need help",
            time: "08.20",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-2222-2222",
            handlerType: .ai,
            status: .pending,
            label: [.warranty],
            handledBy: User(name: "AI Assistant", profileImage: "ai-avatar", email: "ai@example.com"),
            handledAt: "08.20",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Customer B",
            message: "AI: Need help",
            time: "08.20",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-2222-2222",
            handlerType: .ai,
            status: .pending,
            label: [.warranty],
            handledBy: User(name: "AI Assistant", profileImage: "ai-avatar", email: "ai@example.com"),
            handledAt: "08.20",
            seenBy: [],
//            collaborators: []
        ),
        
        Conversation(
            name: "Customer B",
            message: "AI: Need help",
            time: "08.20",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-2222-2222",
            handlerType: .ai,
            status: .pending,
            label: [.warranty],
            handledBy: User(name: "AI Assistant", profileImage: "ai-avatar", email: "ai@example.com"),
            handledAt: "08.20",
            seenBy: [],
//            collaborators: []
        )
    ]
}
