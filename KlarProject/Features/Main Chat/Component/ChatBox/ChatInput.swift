//
//  ChatInputView.swift 
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI

struct ChatInputView: View {
    @State private var messageText: String = ""
    @State private var textHeight: CGFloat = 36
    
    let onSend: (String) -> Void
//    let onAttachment: () -> Void
//    let onAI: () -> Void
    
    private let minHeight: CGFloat = 36
    private let maxHeight: CGFloat = 120
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // Left buttons
//            HStack(spacing: 8) {
//                PaperclipButton(action: onAttachment)
//                RobotButton(action: onAI)
//            }
            
            MacOSTextEditor(
                text: $messageText,
                height: $textHeight,
                minHeight: minHeight,
                maxHeight: maxHeight,
                onEnter: sendMessage
            )
            .frame(height: textHeight)
            .background(Color.avatarCount)
            .cornerRadius(11)
            .overlay(
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(Color.sectionHeader, lineWidth: 1)
                    
                    if messageText.isEmpty {
                        Text("Type your text")
                            .foregroundColor(Color.textRegular.opacity(0.5))
                            .font(.callout)
                            .padding(.leading, 12)
                    }
                }
            )
            if !messageText.isEmpty {
                SendMessageButton(action: sendMessage, isEnabled: true)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.chatInputBackgroundColor)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: messageText.isEmpty)
        .layoutPriority(1)
    }
    
    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            onSend(trimmed)
            messageText = ""
            textHeight = minHeight
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        Color.gray.opacity(0.2)
        
        ChatInputView(
            onSend: {_ in },
//            onAttachment: {},
//            onAI: {}
        )
    }
    .frame(height: 400)
}
