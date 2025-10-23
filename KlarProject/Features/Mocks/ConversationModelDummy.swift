//
//  ConversationModelDummy.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/10/25.
//

import Foundation

struct Conversation: Identifiable {
    let id = UUID()
    let name: String
    let message: String
    let time: String
    let profileImage: String
    let unreadCount: Int
    let hasWhatsApp: Bool
    let phoneNumber: String
    
    let handlerType : handlerType
    let status : statusType?
    
    // Ubah semua waktu ke menit, jadi gampang untuk di compare
    var timeInMinutes : Int {
        let waktu = time.split(separator :".")
        guard waktu.count == 2,
              let jam = Int(waktu[0]),
              let menit = Int(waktu[1]) else {
            return 0
        }
    return  jam * 60 + menit
    }
    
    var sortPriority: Int {
        guard let status = status else {
            return 999 // Human conversations
        }
        
        switch status {
        case .pending: return 1   // Highest priority
        case .open: return 2
        case .resolved: return 3  // Lowest priority
        }
    }
}

enum handlerType {
    case human
    case ai
}
extension Conversation {
    static let dummyData: [Conversation] = [
        Conversation(
            name: "Lil Bahlil",
            message: "Woy min, alat gw rusak nih!",
            time: "14.29",  // Newer - akan di atas
            profileImage: "Pak Lu Hoot",
            unreadCount: 1,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil
        ),
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "01.50",  // Older - akan di bawah
            profileImage: "Pak Lu Hoot",
            unreadCount: 3,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil
        )
        ,
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "01.50",  // Older - akan di bawah
            profileImage: "Pak Lu Hoot",
            unreadCount: 3,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil
        ),
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "21.50",  // Older - akan di bawah
            profileImage: "Pak Lu Hoot",
            unreadCount: 3,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil
        ),
        Conversation(
            name: "Roro Prabroro",
            message: "Tolong MBG di tangsel ditambah itu...",
            time: "11.50",  // Older - akan di bawah
            profileImage: "Pak Lu Hoot",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-1123-1123",
            handlerType: .human,
            status: nil
        )
    ]
    
    static let aiDummy: [Conversation] = [
        Conversation(
            name: "Customer A",
            message: "AI: Urgent!",
            time: "15.30",  // Newer Pending
            profileImage: "person4",
            unreadCount: 2,
            hasWhatsApp: true,
            phoneNumber: "+61-1111-1111",
            handlerType: .ai,
            status: .pending  // Priority 1 - akan paling atas
        ),
        Conversation(
            name: "Customer B",
            message: "AI: Need help",
            time: "08.20",  // Older Pending
            profileImage: "person5",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-2222-2222",
            handlerType: .ai,
            status: .pending  // Priority 1
        ),
        Conversation(
            name: "Customer C",
            message: "AI: Working on it",
            time: "12.00",  // Newer Open
            profileImage: "person4",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-3333-3333",
            handlerType: .ai,
            status: .open  // Priority 2
        ),
        Conversation(
            name: "Customer D",
            message: "AI: In progress",
            time: "06.15",  // Older Open
            profileImage: "person5",
            unreadCount: 1,
            hasWhatsApp: true,
            phoneNumber: "+61-4444-4444",
            handlerType: .ai,
            status: .open  // Priority 2
        ),
        Conversation(
            name: "Customer E",
            message: "AI: All done!",
            time: "16.45",  // Newer Resolved
            profileImage: "person4",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-5555-5555",
            handlerType: .ai,
            status: .resolved  // Priority 3 - akan paling bawah
        ),
        Conversation(
            name: "Customer F",
            message: "AI: Completed",
            time: "02.30",  // Older Resolved
            profileImage: "person5",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-6666-6666",
            handlerType: .ai,
            status: .resolved  // Priority 3
        )
    ]
}
