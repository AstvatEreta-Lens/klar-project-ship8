//
//  EvaluationConversattionDeleteAlert.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 18/11/25.
//


import SwiftUI

struct EvaluationConversationDeleteAlert: View {
    let conversation: Conversation
    let deleteAction: () -> Void
    let cancelAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text("Are you sure want to remove this conversation?")
                .foregroundColor(Color.textRegular)
                .font(.body)
                .fontWeight(.bold)
                .padding(.top, 24)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
            
            // Preview Card - Conversation yang akan dihapus
            VStack(alignment: .leading, spacing: 12) {
                // Latest message
                Text(conversation.message)
                    .foregroundColor(Color.textRegular)
                    .font(.caption)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(alignment: .center, spacing: 8) {
                    // Profile Image
                    Image(conversation.profileImage)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    
                    // Customer Info
                    VStack(alignment: .leading, spacing: 2) {
                        Text(conversation.name)
                            .foregroundColor(Color.textRegular)
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        Text(conversation.phoneNumber)
                            .foregroundColor(Color.avatarCount)
                            .font(.caption2)
                    }
                    
                    Spacer()
                    
                    // Resolved Date
                    if let resolvedDate = conversation.resolvedAt {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Resolved:")
                                .foregroundColor(Color.avatarCount)
                                .font(.caption2)
                            
                            Text(formatShortDate(resolvedDate))
                                .foregroundColor(Color.sectionHeader)
                                .font(.caption2)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 11)
                    .stroke(Color.sectionHeader, lineWidth: 1)
            )
            .padding(.horizontal, 28)
            .padding(.vertical, 8)
            
            Spacer()
            
            // Warning text
            Text("Deleted conversation context cannot be backup. This action cannot be undone.")
                .font(.caption)
                .foregroundColor(Color.textRegular)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
            
            // Remove button
            Button(action: deleteAction) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(Color.textRegular)
                    Text("Remove")
                        .foregroundColor(Color.textRegular)
                        .font(.body)
                        .fontWeight(.bold)
                }
                .frame(width: 308, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 11)
                        .foregroundColor(Color.redStatus)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .cornerRadius(11)
            
            // Cancel button
            Button(action: cancelAction) {
                Text("Cancel")
                    .foregroundColor(Color.sectionHeader)
                    .frame(width: 308, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .foregroundColor(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(Color.sectionHeader, lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 24)
        }
        .frame(width: 400, height: 420)
        .background(Color.white)
        .cornerRadius(11)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.sectionHeader, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    private func formatShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "dd MMM"
            return formatter.string(from: date)
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
        
        EvaluationConversationDeleteAlert(
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
                handledBy: User(name: "AI Assistant", profileImage: "", email: "ai@example.com"),
                handledAt: "16.45",
                handledDate: Date().addingTimeInterval(-3600 * 24),
                isEvaluated: false,
                resolvedAt: Date().addingTimeInterval(-3600 * 23)
            ),
            deleteAction: {
                print("Remove confirmed")
            },
            cancelAction: {
                print("Remove cancelled")
            }
        )
    }
}
