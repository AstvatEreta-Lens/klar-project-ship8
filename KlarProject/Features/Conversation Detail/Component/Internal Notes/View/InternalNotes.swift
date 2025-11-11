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
            if viewModel.notes.isEmpty{
                noInternalNotesView()
            } else if viewModel.isLoading {
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
                                .padding(.horizontal, 15)
                                .id(note.id)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .cornerRadius(11)
                    .background(Color.labelTextColor)
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
                    .foregroundColor(Color.black)
                    .frame(height: textHeight)
                    .background(Color.white)
                    .cornerRadius(11)
                    .overlay(
                        ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 11)
                                .stroke(Color.sectionHeader, lineWidth: 1)
                            
                            if messageText.isEmpty {
                               Text("Type your text")
                                   .foregroundColor(Color.secondaryUsernameText)
                                   .font(.body)
                                   .padding(.leading, 12)
                           }
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
//            .background(Color.labelTextColor)
            .padding(.horizontal, 10)
            .padding(.bottom, 7)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: messageText.isEmpty)
        }
        .frame(minWidth: 307, maxWidth: .infinity,minHeight: 252, maxHeight: .infinity, alignment: .top)
        .background(Color.labelTextColor)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.avatarCount, lineWidth: 1)
        )
        .cornerRadius(11)
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

struct noInternalNotesView : View {
    var body: some View {
        VStack{
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(.system(size: 64))
                .foregroundColor(Color.border)
            Text("There are no internal notes yet")
                .foregroundColor(Color.border)
            Spacer()
        }
        .padding(.vertical, 25)
        .padding(.horizontal)
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


#Preview("No Notes View"){
    noInternalNotesView()
}
