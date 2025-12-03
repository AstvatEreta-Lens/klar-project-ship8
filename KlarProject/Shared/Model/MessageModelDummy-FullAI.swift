//
//  MessageModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 06/11/25.
//

import Foundation

// MARK: - Message Model

struct Message: Identifiable, Codable {
    let id: UUID
    let conversationId: UUID
    let sender: MessageSender
    let content: String
    let timestamp: Date
    var status: MessageStatus

    
    init(
        id: UUID = UUID(),
        conversationId: UUID,
        sender: MessageSender,
        content: String,
        timestamp: Date = Date(),
        status: MessageStatus = .sent,

    ) {
        self.id = id
        self.conversationId = conversationId
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
        self.status = status
    }
    
    
}

// MARK: - Message Sender

enum MessageSender: Codable {
    case customer(Customer)
    case agent(User)
    case system
    
    var displayName: String {
        switch self {
        case .customer(let customer):
            return customer.name
        case .agent(let user):
            return user.name
        case .system:
            return "System"
        }
    }
    
    var isCustomer: Bool {
        if case .customer = self { return true }
        return false
    }
    
    var isAgent: Bool {
        if case .agent = self { return true }
        return false
    }
}

// MARK: - Customer Model

struct Customer: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String
    let phoneNumber: String
    let profileImage: String
    
    init(
        id: UUID = UUID(),
        name: String,
        phoneNumber: String,
        profileImage: String = ""
    ) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.profileImage = profileImage
    }
}

// MARK: - Message Status

//enum MessageStatus: String, Codable {
//    case sending      // Message is being sent
//    case sent         // Message sent successfully
//    case delivered    // Message delivered to recipient
//    case read         // Message read by recipient
//    case failed       // Message failed to send
//    
//    var icon: String {
//        switch self {
//        case .sending: return "clock"
//        case .sent: return "checkmark"
//        case .delivered: return "checkmark.circle"
//        case .read: return "checkmark.circle.fill"
//        case .failed: return "exclamationmark.circle"
//        }
//    }
//    
//    var color: String {
//        switch self {
//        case .sending: return "gray"
//        case .sent: return "gray"
//        case .delivered: return "blue"
//        case .read: return "blue"
//        case .failed: return "red"
//        }
//    }
//}

// MARK: - Message Extensions

extension Message {
    // Check if message is from customer
    var isFromCustomer: Bool {
        sender.isCustomer
    }
    
    // Check if message is from agent
    var isFromAgent: Bool {
        sender.isAgent
    }
    
    // Get formatted timestamp
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    // Get formatted date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }
    
    // Check if message is from today
    var isToday: Bool {
        Calendar.current.isDateInToday(timestamp)
    }
    
    // Check if message failed to send
    var hasFailed: Bool {
        status == .failed
    }
}

// MARK: - Dummy Data

//extension Message {
//    static func dummyMessages(conversationId: UUID, customer: Customer, agent: User) -> [Message] {
//        let now = Date()
//        
//        return [
//            Message(
//                conversationId: conversationId,
//                sender: .customer(customer),
//                content: "Halo min, mesin saya rusak nih. Tiba-tiba mati total.",
//                timestamp: now.addingTimeInterval(-3600),
//                status: .read
//            ),
//            Message(
//                conversationId: conversationId,
//                sender: .agent(agent),
//                content: "Halo! Terima kasih sudah menghubungi kami. Saya akan bantu cek masalahnya. Boleh info tipe mesin dan kapan terakhir service?",
//                timestamp: now.addingTimeInterval(-3500),
//                status: .read
//            ),
//            Message(
//                conversationId: conversationId,
//                sender: .customer(customer),
//                content: "Mesin tipe XZ-500, terakhir service 3 bulan lalu. Sekarang kalau dinyalain cuma bunyi klik aja terus mati.",
//                timestamp: now.addingTimeInterval(-3400),
//                status: .read
//            ),
//            Message(
//                conversationId: conversationId,
//                sender: .agent(agent),
//                content: "Baik, kemungkinan ada masalah di starter motor atau relay. Apakah mesin masih dalam masa garansi?",
//                timestamp: now.addingTimeInterval(-3300),
//                status: .delivered
//            ),
//            Message(
//                conversationId: conversationId,
//                sender: .customer(customer),
//                content: "Iya masih garansi sampai bulan depan. Gimana proses klaimnya?",
//                timestamp: now.addingTimeInterval(-3200),
//                status: .delivered
//            ),
//            Message(
//                conversationId: conversationId,
//                sender: .agent(agent),
//                content: "Perfect! Untuk klaim garansi, saya akan buatkan ticket service. Teknisi kami akan datang dalam 1-2 hari kerja. Perlu saya catat alamat lengkapnya?",
//                timestamp: now.addingTimeInterval(-3100),
//                status: .sent
//            )
//        ]
//    }
//}
