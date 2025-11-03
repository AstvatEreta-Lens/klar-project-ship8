//
//  ChatInputView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI
import AppKit

struct MacOSTextEditor: NSViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let placeholder: String
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as! NSTextView
        
        // Configure text view
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .labelColor
        textView.backgroundColor = .clear
        textView.isRichText = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = true
        
        // Configure scroll view
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        
        return scrollView
    }
    
    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        
        if textView.string != text {
            textView.string = text
        }
        
        // Update height based on content
        let contentHeight = textView.layoutManager?
            .usedRect(for: textView.textContainer!)
            .height ?? minHeight
        
        let newHeight = max(minHeight, min(contentHeight + 16, maxHeight))
        
        if abs(height - newHeight) > 1 {
            DispatchQueue.main.async {
                height = newHeight
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MacOSTextEditor
        
        init(_ parent: MacOSTextEditor) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
    }
}

struct ChatInputView: View {
    @State private var messageText: String = ""
    @State private var textHeight: CGFloat = 36
    
    let onSend: (String) -> Void
    let onAttachment: () -> Void
    let onAI: () -> Void
    
    private let minHeight: CGFloat = 36
    private let maxHeight: CGFloat = 120
    
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
                maxHeight: maxHeight,
                placeholder: "Type your message..."
            )
            .frame(height: textHeight)
            .background(Color.white)
            .cornerRadius(11)
            .overlay(
                RoundedRectangle(cornerRadius: 11)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
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
