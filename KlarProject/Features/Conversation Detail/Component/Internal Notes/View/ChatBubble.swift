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
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showActionButtons: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                UnevenRoundedRectangle(
                    topLeadingRadius: 11,
                    bottomLeadingRadius: isCurrentUser ? 11 : 0,
                    bottomTrailingRadius: isCurrentUser ? 0 : 11,
                    topTrailingRadius: 11
                )
                .fill(isCurrentUser ? Color.secondaryText : Color.secondaryText.opacity(0.5))
                
                VStack(alignment: .leading, spacing: 3) {
                    // Author name
                    Text(note.author.name)
                        .font(.body)
                        .fontWeight(.bold)
                        .padding(.horizontal, 7)
                        .padding(.top, 8)
                        .foregroundColor(Color.textRegular)
                    
                    // Message bubble
                    Text(note.message)
                        .font(.callout)
                        .foregroundColor(Color.textRegular)
                        .padding(.horizontal, 7)
                        .padding(.bottom, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Delete and Edit buttons - only for current user
                if isCurrentUser {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showActionButtons.toggle()
                        }
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.caption)
                            .foregroundColor(Color.textRegular)
                            .padding(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .overlay(alignment: .topTrailing) {
                        if showActionButtons {
                            DeleteAndEditButton(
                                editAction: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showActionButtons = false
                                    }
                                    onEdit()
                                },
                                deleteAction: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showActionButtons = false
                                    }
                                    onDelete()
                                }
                            )
                            .offset(x: 0, y: 25)
                            .transition(.scale.combined(with: .opacity))
                            .zIndex(10)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 1)
            .padding(.trailing, 21)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .accessibilityLabel("Chat bubble")
    }
}

// MARK: - Previews

#Preview("Other User Message") {
    InternalNoteChatBubble(
        note: InternalNote(
            conversationId: UUID(),
            author: User(name: "Indri Kusuma", profileImage: "", email: "indri@example.com"),
            message: "Konsumen tadi minta service mesin karena kerusakan kabel",
            timestamp: Date()
        ),
        isCurrentUser: false,
        onEdit: { print("Edit") },
        onDelete: { print("Delete") }
    )
    .padding()
    .frame(width: 334)
    .background(Color.gray.opacity(0.1))
}

#Preview("Current User Message") {
    InternalNoteChatBubble(
        note: InternalNote(
            conversationId: UUID(),
            author: User(name: "Admin", profileImage: "", email: "admin@example.com"),
            message: "Oke noted, nanti saya proses dengan diskon 30%",
            timestamp: Date()
        ),
        isCurrentUser: true,
        onEdit: { print("Edit") },
        onDelete: { print("Delete") }
    )
    .padding()
    .frame(width: 334)
    .background(Color.gray.opacity(0.1))
}

#Preview("Long Message") {
    InternalNoteChatBubble(
        note: InternalNote(
            conversationId: UUID(),
            author: User(name: "Indri", profileImage: "", email: "indri@example.com"),
            message: "Ini adalah contoh pesan yang sangat panjang untuk menguji bagaimana tampilan chat bubble ketika ada banyak teks. Semoga bisa wrap dengan baik dan tidak overflow.",
            timestamp: Date()
        ),
        isCurrentUser: false,
        onEdit: { print("Edit") },
        onDelete: { print("Delete") }
    )
    .padding()
    .frame(width: 334)
    .background(Color.gray.opacity(0.1))
}

#Preview("Multiple Messages") {
    VStack {
        InternalNoteChatBubble(
            note: InternalNote(
                conversationId: UUID(),
                author: User(name: "Indri", profileImage: "", email: "indri@example.com"),
                message: "Konsumen tadi minta service mesin",
                timestamp: Date().addingTimeInterval(-3600)
            ),
            isCurrentUser: false,
            onEdit: {},
            onDelete: {}
        )
        
        InternalNoteChatBubble(
            note: InternalNote(
                conversationId: UUID(),
                author: User(name: "Ahmad", profileImage: "", email: "ahmad@example.com"),
                message: "Oke saya cek dulu ya",
                timestamp: Date().addingTimeInterval(-3500)
            ),
            isCurrentUser: true,
            onEdit: {},
            onDelete: {}
        )
        
        InternalNoteChatBubble(
            note: InternalNote(
                conversationId: UUID(),
                author: User(name: "Indri", profileImage: "", email: "indri@example.com"),
                message: "Kasih diskon 30% ya karena teman dekat",
                timestamp: Date().addingTimeInterval(-3400)
            ),
            isCurrentUser: false,
            onEdit: {},
            onDelete: {}
        )
        
        InternalNoteChatBubble(
            note: InternalNote(
                conversationId: UUID(),
                author: User(name: "Tech Support", profileImage: "", email: "tech@example.com"),
                message: "Siap, sudah saya input diskon 30% untuk customer ini",
                timestamp: Date().addingTimeInterval(-3300)
            ),
            isCurrentUser: true,
            onEdit: {},
            onDelete: {}
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
                    author: User(name: "Indri", profileImage: "", email: "indri@example.com"),
                    message: "Customer complaint",
                    timestamp: Date()
                ),
                isCurrentUser: false,
                onEdit: {},
                onDelete: {}
            )
            
            InternalNoteChatBubble(
                note: InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Current Admin", profileImage: "", email: "admin@example.com"),
                    message: "I'll handle it",
                    timestamp: Date()
                ),
                isCurrentUser: true,
                onEdit: {},
                onDelete: {}
            )
            
            InternalNoteChatBubble(
                note: InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Budi", profileImage: "", email: "budi@example.com"),
                    message: "Need technical support",
                    timestamp: Date()
                ),
                isCurrentUser: false,
                onEdit: {},
                onDelete: {}
            )
            
            InternalNoteChatBubble(
                note: InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Current Admin", profileImage: "", email: "admin@example.com"),
                    message: "Done! ",
                    timestamp: Date()
                ),
                isCurrentUser: true,
                onEdit: {},
                onDelete: {}
            )
        }
        .padding()
    }
    .frame(width: 334, height: 400)
    .background(Color.gray.opacity(0.1))
}
