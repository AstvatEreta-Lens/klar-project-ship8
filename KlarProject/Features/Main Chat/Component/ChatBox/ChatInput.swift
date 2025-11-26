//
//  ChatInputView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI


struct ChatInputView: View {
    @State private var messageText: String = ""
    @State private var textHeight: CGFloat = 0
    
    let onSend: (String) -> Void
    let onAttachment: () -> Void
    let onAI: () -> Void
    
    private let minHeight: CGFloat = 36
    private let maxHeight: CGFloat = 120
    
    let overlayText : String = "Type your text here...."
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // Left buttons
            HStack(spacing: 8) {
                PaperclipButton(action: onAttachment)
                RobotButton(action: onAI)
            }
            
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
            // Send button
            if !messageText.isEmpty {
                SendMessageButton(action: sendMessage, isEnabled: true)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: messageText.isEmpty)
    }
    
    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            onSend(trimmed)
            messageText = ""
            textHeight = minHeight // Reset height after send
        }
    }
}

#Preview {
    ChatInputView(onSend: {_ in }, onAttachment: {}, onAI: {})
}
