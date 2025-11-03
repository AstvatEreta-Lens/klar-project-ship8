//
//  InternalNotesView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 22/10/25.
//

import SwiftUI

struct InternalNotesView: View {
    @StateObject private var viewModel: InternalNotesViewModel
    @State private var messageText: String = ""
    @State private var scrollProxy: ScrollViewProxy?
    
    let currentUser: User
    
    init(conversationId: UUID, currentUser: User) {
        self._viewModel = StateObject(wrappedValue: InternalNotesViewModel(
            conversationId: conversationId,
            currentUser: currentUser,
            service: MockInternalNotesService.shared
        ))
        self.currentUser = currentUser
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 6) {
                            ForEach(viewModel.notes) { note in
                                InternalNoteChatBubble(
                                    note: note,
                                    isCurrentUser: note.author.id == currentUser.id
                                )
                                .id(note.id)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .onAppear {
                        scrollProxy = proxy
                        scrollToBottom()
                    }
                }
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }

            Divider()

            InternalNoteInputView(
                text: $messageText,
                onSend: sendMessage
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(width: 307, height: 252)
        .cornerRadius(11)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.borderColor, lineWidth: 1)
        )
//        .clipped()
    }

    
    private func sendMessage() {
        viewModel.sendNote(message: messageText)
        messageText = ""
        
        // Scroll to bottom after sending
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            scrollToBottom()
        }
    }
    
    private func scrollToBottom() {
        guard let lastNote = viewModel.notes.last else { return }
        withAnimation {
            scrollProxy?.scrollTo(lastNote.id, anchor: .bottom)
        }
    }
    
}

// MARK: - Previews

#Preview("Empty State") {
    InternalNotesView(
        conversationId: UUID(),
        currentUser: User(name: "Admin", profileImage: "")
    )
    .frame(width: 334)
}

#Preview("With Messages") {
    InternalNotesViewPreview_WithMessages()
//        .frame(width: 334)
        .padding()
}

#Preview("Loading State") {
    InternalNotesViewPreview_Loading()
        .frame(width: 334)
}

#Preview("With Error") {
    InternalNotesViewPreview_Error()
        .frame(width: 334)
}

#Preview("Multiple Users") {
    InternalNotesViewPreview_MultipleUsers()
}

// MARK: - Preview Helpers

struct InternalNotesViewPreview_WithMessages: View {
    @StateObject private var viewModel: InternalNotesViewModel
    @State private var messageText: String = ""
    
    let currentUser = User(name: "Admin", profileImage: "")
    
    init() {
        let conversationId = UUID()
        self._viewModel = StateObject(wrappedValue: InternalNotesViewModel(
            conversationId: conversationId,
            currentUser: User(name: "Admin", profileImage: ""),
            service: MockInternalNotesService.shared
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.notes) { note in
                        InternalNoteChatBubble(
                            note: note,
                            isCurrentUser: note.author.name == "Admin"
                        )
                    }
                }
                .padding(.vertical, 12)
            }
            .frame(height: 200)
            .background(Color.gray.opacity(0.05))
            
            Divider()
            
            InternalNoteInputView(
                text: $messageText,
                onSend: {}
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color.white)
        .onAppear {
            // Simulate loaded messages
            Task {
                await viewModel.loadNotes()
            }
        }
    }
}

struct InternalNotesViewPreview_Loading: View {
    var body: some View {
        VStack(spacing: 0) {
            ProgressView()
                .frame(height: 200)
                .background(Color.gray.opacity(0.05))
            
            Divider()
            
            InternalNoteInputView(
                text: .constant(""),
                onSend: {}
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color.white)
    }
}

struct InternalNotesViewPreview_Error: View {
    @State private var messageText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    // Empty
                }
            }
            .frame(height: 200)
            .background(Color.gray.opacity(0.05))
            
            // Error message
            Text("Failed to load notes. Please try again.")
                .font(.caption)
                .foregroundColor(.red)
                .padding(8)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            
            Divider()
            
            InternalNoteInputView(
                text: $messageText,
                onSend: {}
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color.white)
    }
}

struct InternalNotesViewPreview_MultipleUsers: View {
    let sampleNotes: [InternalNote] = [
        InternalNote(
            conversationId: UUID(),
            author: User(name: "Indri", profileImage: ""),
            message: "Konsumen tadi minta service mesin karena kerusakan kabel",
            timestamp: Date().addingTimeInterval(-3600)
        ),
        InternalNote(
            conversationId: UUID(),
            author: User(name: "Admin", profileImage: ""),
            message: "Oke, saya cek dulu ya",
            timestamp: Date().addingTimeInterval(-3500)
        ),
        InternalNote(
            conversationId: UUID(),
            author: User(name: "Indri", profileImage: ""),
            message: "tapi karena ini temen deket ko Alek jadi kasih diskon 30% ya",
            timestamp: Date().addingTimeInterval(-3400)
        ),
        InternalNote(
            conversationId: UUID(),
            author: User(name: "Ahmad", profileImage: ""),
            message: "Oke noted, nanti saya proses dengan diskon 30%",
            timestamp: Date().addingTimeInterval(-3300)
        ),
        InternalNote(
            conversationId: UUID(),
            author: User(name: "Admin", profileImage: ""),
            message: "Perfect, thanks team! 👍",
            timestamp: Date().addingTimeInterval(-3200)
        )
    ]
    
    @State private var messageText: String = ""
    let currentUser = User(name: "Admin", profileImage: "")
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(sampleNotes) { note in
                        InternalNoteChatBubble(
                            note: note,
                            isCurrentUser: note.author.id == currentUser.id
                        )
                    }
                }
                .padding(.vertical, 12)
            }
            .frame(height: 200)
            .background(Color.gray.opacity(0.05))
            
            Divider()
            
            InternalNoteInputView(
                text: $messageText,
                onSend: {
                    print("Send: \(messageText)")
                }
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color.white)
    }
}
