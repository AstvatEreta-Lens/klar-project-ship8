//
//  ChatBubble.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI

struct InternalNoteChatBubble: View {
    let note: InternalNote
    let isCurrentUser: Bool
    
    var body: some View {
            ZStack{
                UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 11,
                    bottomTrailingRadius: 11,
                    topTrailingRadius: 11
                )
                .fill(Color.bubbleChatColor)
                
                VStack(alignment: .leading, spacing: 3) {
                    // Author name
                    Text(note.author.name)
                        .font(.caption)
                        .padding(.horizontal, 7)
                        .padding(.top, 8)
                        .foregroundColor(.primary)
                    
                    // Message bubble
                    Text(note.message)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 7)
                        .padding(.bottom, 8)
                        .frame(maxWidth: 280, alignment: .leading)
                }
            }
            .padding(.top, 1)
            .padding(.trailing, 21)
            Spacer()  // Push everything to left
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }
}

// MARK: - Previews

#Preview("Other User Message") {
    InternalNoteChatBubble(
        note: InternalNote(
            conversationId: UUID(),
            author: User(name: "Indri Kusuma", profileImage: ""),
            message: "Konsumen tadi minta service mesin karena kerusakan kabel",
            timestamp: Date()
        ),
        isCurrentUser: false
    )
    .padding()
    .frame(width: 334)
    .background(Color.gray.opacity(0.1))
}

#Preview("Current User Message") {
    InternalNoteChatBubble(
        note: InternalNote(
            conversationId: UUID(),
            author: User(name: "Admin", profileImage: ""),
            message: "Oke noted, nanti saya proses dengan diskon 30%",
            timestamp: Date()
        ),
        isCurrentUser: true
    )
    .padding()
    .frame(width: 334)
    .background(Color.gray.opacity(0.1))
}

#Preview("Long Message") {
    InternalNoteChatBubble(
        note: InternalNote(
            conversationId: UUID(),
            author: User(name: "Indri", profileImage: ""),
            message: "Ini adalah contoh pesan yang sangat panjang untuk menguji bagaimana tampilan chat bubble ketika ada banyak teks. Semoga bisa wrap dengan baik dan tidak overflow.人们你好， 现在我又冰淇淋， 和有速度与一级九，但是我更喜欢冰淇淋，所以如果你们不喜欢冰淇淋， 你们不是我的朋友。如果你们可以写这个故事，拜拜 你妈妈很美",
            timestamp: Date()
        ),
        isCurrentUser: false
    )
    .padding()
    .frame(width: 334)
    .background(Color.gray.opacity(0.1))
}

#Preview("Multiple Messages") {
    VStack{
        InternalNoteChatBubble(
            note: InternalNote(
                conversationId: UUID(),
                author: User(name: "Indri", profileImage: ""),
                message: "Konsumen tadi minta service mesin",
                timestamp: Date().addingTimeInterval(-3600)
            ),
            isCurrentUser: false
        )
        
        InternalNoteChatBubble(
            note: InternalNote(
                conversationId: UUID(),
                author: User(name: "Ahmad", profileImage: ""),
                message: "Oke saya cek dulu ya",
                timestamp: Date().addingTimeInterval(-3500)
            ),
            isCurrentUser: true
        )
        
        InternalNoteChatBubble(
            note: InternalNote(
                conversationId: UUID(),
                author: User(name: "Indri", profileImage: ""),
                message: "Kasih diskon 30% ya karena temen deket",
                timestamp: Date().addingTimeInterval(-3400)
            ),
            isCurrentUser: false
        )
        
        InternalNoteChatBubble(
            note: InternalNote(
                conversationId: UUID(),
                author: User(name: "Tech Support", profileImage: ""),
                message: "Siap, sudah saya input diskon 30% untuk customer ini",
                timestamp: Date().addingTimeInterval(-3300)
            ),
            isCurrentUser: true
        )
    }
    .padding()
    .frame(width: 334)
    .background(Color.gray.opacity(0.1))
}

#Preview("Different Users") {
    ScrollView {
        VStack(spacing: 12) {
            InternalNoteChatBubble(
                note: InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Indri", profileImage: ""),
                    message: "Customer complaint",
                    timestamp: Date()
                ),
                isCurrentUser: false
            )
            
            InternalNoteChatBubble(
                note: InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Current Admin", profileImage: ""),
                    message: "I'll handle it",
                    timestamp: Date()
                ),
                isCurrentUser: true
            )
            
            InternalNoteChatBubble(
                note: InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Budi", profileImage: ""),
                    message: "Need technical support",
                    timestamp: Date()
                ),
                isCurrentUser: false
            )
            
            InternalNoteChatBubble(
                note: InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Current Admin", profileImage: ""),
                    message: "Done! ✅",
                    timestamp: Date()
                ),
                isCurrentUser: true
            )
        }
        .padding()
    }
    .frame(width: 334, height: 400)
    .background(Color.gray.opacity(0.1))
}
