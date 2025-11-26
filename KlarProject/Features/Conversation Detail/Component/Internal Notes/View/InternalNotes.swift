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
    @State private var textHeight: CGFloat = 0
    
    let currentUser: User
    let onSend: () -> Void
    
    private let minHeight: CGFloat = 36
    private let maxHeight: CGFloat = 120
    
    init(conversationId: UUID, currentUser: User) {
        self._viewModel = StateObject(wrappedValue: InternalNotesViewModel(
            conversationId: conversationId,
            currentUser: currentUser,
            service: MockInternalNotesService.shared
        ))
        self.currentUser = currentUser
        self.onSend = { }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing : -6){
                            ForEach(viewModel.notes) { note in
                                InternalNoteChatBubble(
                                    note: note,
                                    isCurrentUser: note.author.id == currentUser.id
                                )
                                .padding(.horizontal, 5)
                                .id(note.id)
                            }
                        }
                        .padding(.top, 8)
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
            
            //            InternalNoteInputView(
            //                text: $messageText,
            //                onSend: sendMessage
            //            )
            
            HStack(spacing: 8) {
                // Text input
                ZStack(alignment: .leading){
                    MacOSTextEditor(
                        text: $messageText,
                        height: $textHeight,
                        minHeight: minHeight,
                        maxHeight: maxHeight
                    )
                    .frame(height: textHeight)
                    .background(Color.white)
                    .cornerRadius(11)
                    .overlay(
                        ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 11)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            
                            Text(!messageText.isEmpty ? "" : "Type your text...")
                                .foregroundStyle(Color.black.opacity(0.3))
                                .padding(.leading, 9)
                        }
                    )
                }
                // Send button
                if !messageText.isEmpty {
                    SendMessageButton(
                        action: {
                            sendMessage()
                            messageText = messageText
                        },
                        isEnabled: true
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 7)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: messageText.isEmpty)
        }
        .frame(
            width: 307,
            height: 252)
        .cornerRadius(11)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.avatarCount, lineWidth: 1)
        )
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
    .padding()
}
