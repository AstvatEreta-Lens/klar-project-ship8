//
//  MessageBubble.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 23/11/25.
//
import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    @EnvironmentObject var chatViewModel: MainChatViewModel
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromUser {
                Spacer()
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                // Message text with highlighting
                Text(chatViewModel.highlightedText(for: message))
                    .font(.body)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(message.isFromUser ? Color(hex: "#C0E3FF") : Color(hex: "#F5F5F5"))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                    .frame(maxWidth: 450, alignment: message.isFromUser ? .trailing : .leading)
                
                // Timestamp and status
                HStack(spacing: 4) {
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if message.isFromUser {
                        statusIcon(for: message.status)
                    }
                }
                .padding(.horizontal, 5)
            }
            
            if !message.isFromUser {
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func statusIcon(for status: MessageStatus) -> some View {
        Group {
            switch status {
            case .sending:
                Image(systemName: "clock")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            case .sent:
                Image(systemName: "checkmark")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            case .delivered:
                HStack(spacing: -4) {
                    Image(systemName: "checkmark")
                    Image(systemName: "checkmark")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            case .read:
                HStack(spacing: -4) {
                    Image(systemName: "checkmark")
                    Image(systemName: "checkmark")
                }
                .font(.caption2)
                .foregroundColor(.blue)
            case .failed:
                Image(systemName: "exclamationmark.circle")
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
    }
}
