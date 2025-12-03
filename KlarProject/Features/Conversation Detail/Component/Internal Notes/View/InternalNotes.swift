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
    @State private var textHeight: CGFloat = 36
    @FocusState private var isInputFocused: Bool
    
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
            if viewModel.notes.isEmpty {
                noInternalNotesView()
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: -6) {
                            ForEach(viewModel.notes) { note in
                                InternalNoteChatBubble(
                                    note: note,
                                    isCurrentUser: note.author.id == currentUser.id,
                                    onEdit: {
                                        handleEditNote(note)
                                    },
                                    onDelete: {
                                        handleDeleteNote(note)
                                    }
                                )
                                .padding(.horizontal, 15)
                                .id(note.id)
                            }
                        }
                        
                        .accessibilityLabel("Internal Notes")
                        .padding(.top, 8)
                    }
                    .cornerRadius(11)
                    .background(Color.backgroundTertiary)
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
            
            // Input View
            inputView
        }
        .frame(minWidth: 307, maxWidth: .infinity, minHeight: 252, maxHeight: .infinity, alignment: .top)
        .background(Color.backgroundTertiary)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.avatarCount, lineWidth: 1)
        )
        .cornerRadius(11)
        .onChange(of: viewModel.editingNote) { oldValue, newValue in
            if let editingNote = newValue {
                messageText = editingNote.message
                isInputFocused = true
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        viewModel.sendNote(message: messageText)
        messageText = ""
        
        // Scroll to bottom after sending
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            scrollToBottom()
        }
    }
    
    private func handleEditNote(_ note: InternalNote) {
        viewModel.startEditingNote(note)
    }
    
    private func handleDeleteNote(_ note: InternalNote) {
        withAnimation {
            viewModel.deleteNote(note)
        }
    }
    
    private func cancelEdit() {
        viewModel.cancelEditing()
        messageText = ""
        isInputFocused = false
    }
    
    private func scrollToBottom() {
        guard let lastNote = viewModel.notes.last else { return }
        withAnimation {
            scrollProxy?.scrollTo(lastNote.id, anchor: .bottom)
        }
    }
    
    // MARK: - Input View Components
    
    private var inputView: some View {
        HStack(spacing: 8) {
            textEditorView
            
            if !messageText.isEmpty {
                SendMessageButton(
                    action: {
                        sendMessage()
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
    
    private var textEditorView: some View {
        ZStack(alignment: .leading) {
            MacOSTextEditor(
                text: $messageText,
                height: $textHeight,
                minHeight: minHeight,
                maxHeight: maxHeight,
                onEnter: {
                    if !messageText.isEmpty {
                        Text("Type your text...")
                            .foregroundColor(Color.textRegular)
                            .font(.callout)
                        sendMessage()
                    }
                }
            )
            .foregroundColor(Color.textRegular)
            .frame(height: textHeight)
            .background(Color.backgroundTertiary.opacity(0.9))
            .cornerRadius(11)
            .overlay(textEditorOverlay) // meski klik diatas "type your text" tetap bisa di klik untuk input
            .focused($isInputFocused) // dengan is focused, keyboard input akan terfokus disini
            .onKeyPress(.escape) {
                handleEscapeKey()
            }
        }
    }
    
    private var textEditorOverlay: some View {
        ZStack(alignment: .leading) {
            borderView
            placeholderView
        }
    }
    
    private var borderView: some View {
        RoundedRectangle(cornerRadius: 11)
            .stroke(
                viewModel.isEditMode ? Color.sectionHeader : Color.sectionHeader,
                lineWidth: viewModel.isEditMode ? 1 : 1
            )
    }
    
    @ViewBuilder
    private var placeholderView: some View {
        if messageText.isEmpty {
            Text(viewModel.isEditMode ? "Editing message" : "Type your text")
                .foregroundColor(Color.textRegular)
                .font(.callout)
                .padding(.leading, 12)
                .allowsHitTesting(false) // tap gesture akan tembus ke MacOSTextEditor
        }
    }
    
    
    private func handleReturnKey() -> KeyPress.Result {
        if !messageText.isEmpty {
            sendMessage()
            return .handled
        }
        return .ignored
    }
    
    private func handleEscapeKey() -> KeyPress.Result {
        if viewModel.isEditMode {
            cancelEdit()
            return .handled
        }
        return .ignored
    }
}

struct noInternalNotesView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(.system(size: 64))
                .foregroundColor(Color.secondaryText.opacity(0.9))
            Text("There are no internal notes yet")
                .font(.callout)
                .foregroundColor(Color.secondaryText)
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
        currentUser: User(name: "Admin", profileImage: "", email: "admin@example.com")
    )
    .frame(width: 334)
    .padding()
}

#Preview("No Notes View") {
    noInternalNotesView()
}
