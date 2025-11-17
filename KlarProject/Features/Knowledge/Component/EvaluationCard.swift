//
//  EvaluationCard.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 12/11/25.
//

import SwiftUI

struct EvaluationCard: View {
    let conversation: Conversation
    let state: CardStateColor
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Latest message
                Text(conversation.message)
                    .foregroundColor(state.textColor)
                    .font(.body)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 12) {
                    // Profile Image
                    Image(conversation.profileImage)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    // Customer Info
                    VStack(alignment: .leading, spacing: 2) {
                        Text(conversation.name)
                            .foregroundColor(state.textColor)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    // Resolved Date
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Last resolved:")
                            .foregroundColor(Color.textRegular)
                            .font(.caption)
                        
                        if let resolvedDate = conversation.resolvedAt {
                            Text(formatDate(resolvedDate))
                                .foregroundColor(Color.avatarCount)
                                .font(.caption)
                                .fontWeight(.medium)
                        } else {
                            Text("N/A")
                                .foregroundColor(Color.avatarCount)
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 128)
            .background(state.basicColor)
            .cornerRadius(11)
            .overlay(
                RoundedRectangle(cornerRadius: 11)
                    .stroke(state.basicColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Helper Functions
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        // Check if date is today
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return "Today, \(formatter.string(from: date))"
        }
        
        // Check if date is yesterday
        if Calendar.current.isDateInYesterday(date) {
            formatter.dateFormat = "HH:mm"
            return "Yesterday, \(formatter.string(from: date))"
        }
        
        // For older dates
        let daysDifference = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        
        if daysDifference < 7 {
            // Within a week - show day name
            formatter.dateFormat = "EEEE, HH:mm"
            return formatter.string(from: date)
        } else {
            // Older than a week - show full date
            formatter.dateFormat = "dd MMM yyyy"
            return formatter.string(from: date)
        }
    }
}

// MARK: - Previews

#Preview("Unevaluated Card") {
    VStack {
        EvaluationCard(
            conversation: Conversation(
                name: "Pak Daud",
                message: "Mesin rusak terkena air serta terendam kecap. Dan Customer complain mengenai suaranya yang berisik",
                time: "16.45",
                profileImage: "Photo Profile",
                unreadCount: 0,
                hasWhatsApp: true,
                phoneNumber: "+62 883-3443-4458",
                handlerType: .ai,
                status: .resolved,
                handledBy: User(name: "AI", profileImage: "", email: "ai@example.com"),
                handledAt: "16.45",
                isEvaluated: false,
                resolvedAt: Date().addingTimeInterval(-3600 * 23)
            ),
            state: .unevaluated,
            onTap: { print("Card tapped") }
        )
    }
    .padding()
}

#Preview("Selected Card") {
    VStack {
        EvaluationCard(
            conversation: Conversation(
                name: "Pak Daud",
                message: "Mesin rusak terkena air serta terendam kecap. Dan Customer complain mengenai suaranya yang berisik",
                time: "16.45",
                profileImage: "Photo Profile",
                unreadCount: 0,
                hasWhatsApp: true,
                phoneNumber: "+62 883-3443-4458",
                handlerType: .ai,
                status: .resolved,
                handledBy: User(name: "AI", profileImage: "", email: "ai@example.com"),
                handledAt: "16.45",
                isEvaluated: false,
                resolvedAt: Date().addingTimeInterval(-3600 * 23)
            ),
            state: .selected,
            onTap: { print("Card tapped") }
        )
    }
    .padding()
}
