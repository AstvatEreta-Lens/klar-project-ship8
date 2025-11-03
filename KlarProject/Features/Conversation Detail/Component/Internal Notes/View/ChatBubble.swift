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
        HStack(alignment: .top, spacing: 8) {
            // Alignment jika current user maka di sebelah kanan
            // Jika !current user maka di sebelah kiri
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                // Author name (only for other users)
                if !isCurrentUser {
                    Text(note.author.name)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                // Message bubble
                Text(note.message)
                    .font(.system(size: 14))
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isCurrentUser ? Color.blue : Color.gray.opacity(0.15))
                    )
                    .frame(maxWidth: 400, alignment: isCurrentUser ? .trailing : .leading)
            }
            
            if isCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
    }
}


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
}

#Preview("Long Message") {
    InternalNoteChatBubble(
        note: InternalNote(
            conversationId: UUID(),
            author: User(name: "Indri", profileImage: ""),
            message: "Ini adalah contoh pesan yang sangat panjang untuk menguji bagaimana tampilan chat bubble ketika ada banyak teks. Semoga bisa wrap dengan baik dan tidak overflow.",
            timestamp: Date()
        ),
        isCurrentUser: false
    )
    .padding()
    .frame(width: 334)
}

#Preview("Multiple Messages") {
    VStack(spacing: 12) {
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
    }
    .padding()
    .frame(width: 334)
}
