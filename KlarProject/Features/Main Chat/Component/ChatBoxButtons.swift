//
//  ChatBoxButtons.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI

struct ChatBoxButton: View {
    let icon: String
    let backgroundColor: Color
    let iconColor: Color
    let rotation: Double
    let action: () -> Void
    
    init(
        icon: String,
        backgroundColor: Color = Color.sectionHeader,
        iconColor: Color = Color.borderColor,
        rotation: Double = 0,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.iconColor = iconColor
        self.rotation = rotation
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 11)
                    .fill(Color.backgroundPrimary)
                    .frame(width: 36, height: 36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(Color.sectionHeader, lineWidth: 1)
                    )
                
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(Color.sectionHeader)
                    .rotationEffect(.degrees(rotation))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PaperclipButton: View {
//    @StateObject private var vm = ChatViewModel()
    @State private var showFilePicker = false
    
    let action: () -> Void
    
    var body: some View {
        ChatBoxButton(
            icon: "paperclip",
            action: action
        )
    }
}

struct RefreshButton: View {
    let action: () -> Void
    
    var body: some View {
        ChatBoxButton(
            icon: "arrow.clockwise",
            rotation: 45,
            action: action
        )
    }
}

struct RobotButton: View {
    let action: () -> Void
    
    var body: some View {
        ChatBoxButton(
            icon: "sparkles",
            action: action
        )
    }
}

struct SendMessageButton: View {
    let action: () -> Void
    let isEnabled: Bool
    
    init(action: @escaping () -> Void, isEnabled: Bool = true) {
        self.action = action
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 11)
                    .fill(isEnabled ? Color.sectionHeader : Color.sectionHeader.opacity(0.5))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "paperplane.fill")
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
}

struct ChatInputButtons: View {
    let onAttachment: () -> Void
//    let onRefresh: () -> Void
    let onAI: () -> Void
    let onSend: () -> Void
    let showSendButton: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            PaperclipButton(action: onAttachment)
//            RefreshButton(action: onRefresh)
            RobotButton(action: onAI)
            
            Spacer()
            
            if showSendButton {
                SendMessageButton(action: onSend, isEnabled: true)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showSendButton)
    }
}

#Preview("Paperclip Button") {
    PaperclipButton(action: {})
        .padding()
}

#Preview("Refresh Button") {
    RefreshButton(action: {})
        .padding()
}

#Preview("Robot Button") {
    RobotButton(action: {})
        .padding()
}

#Preview("Send Message Button"){
        SendMessageButton(action: {}, isEnabled: true)
    .padding()
}
