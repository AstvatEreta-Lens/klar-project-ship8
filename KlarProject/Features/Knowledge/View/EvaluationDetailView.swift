//
//  EvaluationDetailView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 13/11/25.
//


import SwiftUI

struct EvaluationDetailView: View {
    let conversation: Conversation
    let canApprove: Bool
    let onRemove: () -> Void
    let onEdit: () -> Void
    let onApprove: () -> Void
    
    @State private var showingRemoveConfirmation = false
    
    var body: some View {
        VStack(spacing: 0) {
            EvaluationHeaderView(conversation: conversation)
            
            Divider()
                .foregroundColor(Color.sectionHeader)
            
            ScrollView {
                    // Messages Section dari al
                    
//                    MessagesSection(conversation: conversation)
            }
            
            Divider()
                .foregroundColor(Color.sectionHeader)
            
            // Buttons
            HStack(spacing: 12) {
                // Remove Button
                Button(action: {
                    showingRemoveConfirmation = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "trash")
                            .foregroundColor(Color.textRegular)
                            .font(.body)
                        Text("Remove")
                            .foregroundColor(Color.textRegular)
                            .font(.body)
//                            .fontWeight(.medium)
                    }
                    .frame(width : 101, height : 36)
                    .padding(.vertical, 5)
                    .background(Color.redStatus)
                    .cornerRadius(11)
                    .overlay(RoundedRectangle(cornerRadius: 11).stroke(Color.textRegular))
                }
                .buttonStyle(PlainButtonStyle())
                
                // Edit Button (for future implementation)
                Button(action: onEdit) {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil")
                            .foregroundColor(Color.textRegular)
                            .font(.body)
                        Text("Edit")
                            .foregroundColor(Color.textRegular)
                            .font(.body)
                    }
                    .frame(width : 71, height : 36)
                    .padding(.vertical, 5)
                    .background(Color.yellowStatusColor)
                    .cornerRadius(11)
                    .overlay(RoundedRectangle(cornerRadius: 11).stroke(Color.textRegular))
                }
                .buttonStyle(PlainButtonStyle())
//                .disabled(true)
                
                // Approve Button
                Button(action: onApprove) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.bubbleChat)
                            .font(.body)
                        Text("Approve")
                            .foregroundColor(Color.bubbleChat)
                            .font(.body)
                    }
                    .frame(width : 108, height : 36)
                    .padding(.vertical, 5)
                    .background(canApprove ? Color.sectionHeader : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(11)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!canApprove)
                .opacity(canApprove ? 1.0 : 0.5)
                
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .alert("Remove Conversation", isPresented: $showingRemoveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                onRemove()
            }
        } message: {
            Text("Yakin?")
        }
    }
}


struct EvaluationHeaderView: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image
            Image(conversation.profileImage)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.borderColor.opacity(0.3), lineWidth: 1)
                )
            
            // Customer Info
            VStack(alignment: .leading, spacing: 6) {
                Text(conversation.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.textRegular)
                
                HStack(spacing: 4) {
                    Text(conversation.phoneNumber)
                        .font(.body)
                        .foregroundColor(Color.avatarCount)
                    
                }
                if conversation.hasWhatsApp {
                    HStack{
                        Image("whatsapp")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text("WhatsApp")
                            .foregroundColor(Color.textRegular)
                    }
                }
            }
            
            Spacer()
            
            // Last Resolved Info
            VStack(alignment: .leading, spacing: 4) {
                Text("Last Conversation:")
                    .font(.caption)
                    .foregroundColor(Color.avatarCount)
                
                if let resolvedDate = conversation.resolvedAt {
                    Text("\(formatDate(resolvedDate))")
                        .font(.caption)
                        .foregroundColor(Color.secondaryText)
                }
                Text("Handled By : ")
                    .font(.caption)
                    .foregroundColor(Color.avatarCount)
                
                // Betulin ntar
                Text("\(conversation.handledBy)")
                    .font(.caption)
                    .foregroundColor(Color.secondaryText)
                
                
            }
            
            AISummarySection(conversation: conversation)
            
        }
        .padding()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Customer Info Section

struct CustomerInfoSection: View {
    let conversation: Conversation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Customer Information")
                .font(.headline)
                .foregroundColor(Color.textRegular)
            
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(label: "Name", value: conversation.name)
                InfoRow(label: "Phone", value: conversation.phoneNumber)
                
                if let handledDate = conversation.handledDate as Date? {
                    InfoRow(label: "Handled At", value: formatDateTime(handledDate))
                }
                
                // Labels
                if !conversation.label.isEmpty {
                    HStack(spacing: 8) {
                        Text("Labels:")
                            .font(.body)
                            .foregroundColor(Color.secondaryText)
                      
                    }
                }
            }
        }
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Info Row Component

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(label):")
                .font(.body)
                .foregroundColor(Color.secondaryText)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.body)
                .foregroundColor(Color.textRegular)
            
            Spacer()
        }
    }
}

// MARK: - AI Summary Section

struct AISummarySection: View {
    let conversation: Conversation
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("AI Summary")
                    .font(.caption)
                    .foregroundColor(Color.textRegular)
            }
            
            // Placeholder for AI Summary
            Text("Customer Pak Daud mengajukan komplain mengenai kerusakan mesin EAC tipe 605H akibat kemasukan cairan.")
                .font(.caption)
                .italic()
                .foregroundColor(Color.avatarCount)
                .cornerRadius(8)
                .padding()
            
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.sectionHeader, lineWidth: 1)
                )
        }
    }
}


// MARK: - Previews

#Preview("Evaluation Detail - Unevaluated") {
    EvaluationDetailView(
        conversation: Conversation(
            name: "Pak Daud",
            message: "Mesin rusak terkena air serta terendam kecap.",
            time: "16.45",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+62 883-3443-4458",
            handlerType: .ai,
            status: .resolved,
            label: [.maintenance, .service],
            handledBy: User(name: "AI Assistant", profileImage: "", email: "ai@example.com"),
            handledAt: "16.45",
            handledDate: Date().addingTimeInterval(-3600 * 24),
            isEvaluated: false,
            resolvedAt: Date().addingTimeInterval(-3600 * 23),
            internalNotes: [
                InternalNote(
                    conversationId: UUID(),
                    author: User(name: "Tech Team", profileImage: "", email: "tech@example.com"),
                    message: "Scheduled maintenance for tomorrow",
                    timestamp: Date().addingTimeInterval(-3600 * 2)
                )
            ]
        ),
        canApprove: true,
        onRemove: { print("Remove tapped") },
        onEdit: { print("Edit tapped") },
        onApprove: { print("Approve tapped") }
    )
    .frame(width: 750, height: 800)
}

#Preview("Evaluation Detail - Evaluated") {
    EvaluationDetailView(
        conversation: Conversation(
            name: "Customer F",
            message: "AI: Completed",
            time: "02.30",
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: "+61-6666-6666",
            handlerType: .ai,
            status: .resolved,
            label: [],
            handledBy: User(name: "AI Assistant", profileImage: "", email: "ai@example.com"),
            handledAt: "02.30",
            handledDate: Date().addingTimeInterval(-3600 * 48),
            isEvaluated: true,
            evaluatedAt: Date().addingTimeInterval(-3600 * 24),
            resolvedAt: Date().addingTimeInterval(-3600 * 47)
        ),
        canApprove: false,
        onRemove: { print("Remove tapped") },
        onEdit: { print("Edit tapped") },
        onApprove: { print("Approve tapped") }
    )
    .frame(width: 750, height: 800)
}
