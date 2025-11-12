//
//  Extension.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 11/11/25.
//

import Foundation
import Combine


// MARK: - Dummy Data
extension Conversation {
    static var humanDummyData: [Conversation] {
        let user1 = User(name: "Admin 1", profileImage: "person.circle", email: "admin1@example.com")
        
        return [
            Conversation(
                name: "John Doe",
                message: "Terima kasih atas bantuannya!",
                time: "14.30",
                phoneNumber: "+6282216860317",
                handlerType: .human,
                status: nil,
                label: [.warranty, .service],
                handledBy: user1,
                handledAt: "14.25",
                messages: [
                    Message(conversationId: UUID(), phoneNumber: "+6282216860317", content: "Halo, saya butuh bantuan", isFromUser: true),
                    Message(conversationId: UUID(), phoneNumber: "+6282216860317", content: "Halo, dengan senang hati saya bantu", isFromUser: false)
                ]
            )
        ]
    }
    
    static var aiDummyData: [Conversation] {
        return [
            Conversation(
                name: "Jane Smith",
                message: "Kapan produk saya dikirim?",
                time: "15.45",
                phoneNumber: "+628987654321",
                handlerType: .ai,
                status: .pending,
                label: [.warranty],
                messages: [
                    Message(conversationId: UUID(), phoneNumber: "+628987654321", content: "Kapan produk saya dikirim?", isFromUser: true)
                ]
            )
        ]
    }
}

