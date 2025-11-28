//
//  InputView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI

struct InternalNoteInputView: View {
    @Binding var text: String
    @State private var textHeight: CGFloat = 36
    
    let onSend: () -> Void
    
    private let minHeight: CGFloat = 36
    private let maxHeight: CGFloat = 80
    
    var body: some View {
        HStack(spacing: 8) {
            // Text input
            ZStack(alignment: .leading){
                if text.isEmpty {
                    Text("Type your text...")
                        .foregroundColor(Color(hex: "#333333"))
                        .font(.callout)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 11)
                }
                
                TextEditor(text: $text)
                    .foregroundColor(Color.primaryTextColor)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 11)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .frame(height: minHeight)
            .background(Color.white)
            .cornerRadius(11)
            .overlay(
                RoundedRectangle(cornerRadius: 11)
                    .stroke(Color.sectionHeader, lineWidth: 1)
            )
            // Send button
            if !text.isEmpty {
                SendMessageButton(
                    action: {
                        onSend()
                        text = ""
                    },
                    isEnabled: true
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: text.isEmpty)
    }
}

#Preview("Empty") {
    InternalNoteInputView(
        text: .constant(""),
        onSend: { print("Send") }
    )
    .padding()
    .frame(width: 334)
}

#Preview("With Text") {
    InternalNoteInputView(
        text: .constant("Hello, this is a test message"),
        onSend: { print("Send") }
    )
    .padding()
    .frame(width: 334)
}

#Preview("Long Text") {
    InternalNoteInputView(
        text: .constant("This is a very long message that should wrap to multiple lines to test the auto-expanding behavior of the text editor component.This is a very long message that should wrap to multiple lines to test the auto-expanding behavior of the text editor component.This is a very long message that should wrap to multiple lines to test the auto-expanding behavior of the text editor component."),
        onSend: { print("Send") }
    )
    .padding()
    .frame(width: 334)
}

#Preview("Multiple States") {
    VStack(spacing: 20) {
        Text("Empty State")
            .font(.headline)
        InternalNoteInputView(
            text: .constant(""),
            onSend: {}
        )
        
        Divider()
        
        Text("With Text")
            .font(.headline)
        InternalNoteInputView(
            text: .constant("Test message"),
            onSend: {}
        )
    }
    .padding()
    .frame(width: 334)
}
