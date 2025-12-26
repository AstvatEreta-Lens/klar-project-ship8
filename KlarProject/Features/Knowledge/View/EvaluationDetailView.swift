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
    @State private var showingApproveSuccess = false
    
    var body: some View {
        ZStack {
            // Main Content
            VStack(spacing: 0) {
                EvaluationHeaderView(conversation: conversation, user: conversation.handledBy)
                
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
                        }
                        .frame(minWidth: 100)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
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
                        .frame(minWidth: 80)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.yellowStatusColor)
                        .cornerRadius(11)
                        .overlay(RoundedRectangle(cornerRadius: 11).stroke(Color.textRegular))
                    }
                    .buttonStyle(PlainButtonStyle())


                    // Approve Button
                    Button(action: {
                        showingApproveSuccess = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.bubbleChat)
                                .font(.body)
                            Text("Approve")
                                .foregroundColor(Color.bubbleChat)
                                .font(.body)
                        }
                        .frame(minWidth: 110)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
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
            
            // Custom Delete Alert Overlay
            if showingRemoveConfirmation {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingRemoveConfirmation = false
                    }
                
                EvaluationConversationDeleteAlert(
                    conversation: conversation,
                    deleteAction: {
                        showingRemoveConfirmation = false
                        onRemove()
                    },
                    cancelAction: {
                        showingRemoveConfirmation = false
                    }
                )
            }
            
            // Approve Success Alert Overlay
            if showingApproveSuccess {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                ContextSuccessfullyEvaluated(
                    continueAction: {
                        showingApproveSuccess = false
                        onApprove()
                    }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct EvaluationHeaderView: View {
    let conversation: Conversation
    let user : User
    
    var body: some View {
        // Profile and Customer Info
        HStack(alignment: .top, spacing: 16) {
            // Profile Image and Customer Info Section
            HStack(spacing: 16) {
                // Profile Image
                Image(conversation.profileImage)
                    .resizable()
                    .scaledToFit()
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
                        .lineLimit(1)
                    
                    Text(conversation.phoneNumber)
                        .font(.body)
                        .foregroundColor(Color.avatarCount)
                        .lineLimit(1)
                    
                    if conversation.hasWhatsApp {
                        HStack(spacing: 4) {
                            Image("whatsapp")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            Text("WhatsApp")
                                .foregroundColor(Color.textRegular)
                                .font(.caption)
                        }
                    }
                }
            }
            .frame(minWidth: 200, maxWidth: .infinity, alignment: .leading)
            
            // Last Conversation Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Last Conversation")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                
                Text(conversation.handledDate.formattedShortDayDate())
                    .font(.caption)
                    .foregroundColor(Color.sectionHeader)
                    .lineLimit(1)
                
                Text("Handled by: ")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                
                Text(user.name)
                    .font(.caption)
                    .foregroundColor(Color.sectionHeader)
                    .lineLimit(1)
            }
            .frame(minWidth: 150, maxWidth: 200, alignment: .leading)
            
            // AI Summary Section
            VStack(alignment: .leading, spacing: 4) {
                Text("AI Summary")
                    .font(.caption)
                    .foregroundColor(Color.textRegular)
                
                // Ganti dengan ai summarry (tembak api, blm buat)
                Text("Customer Pak Daud mengajukan komplain mengenai kerusakan mesin EAC tipe 605H akibat kemasukan cairan.")
                    .font(.caption)
                    .foregroundColor(Color.avatarCount)
                    .lineLimit(3)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .topLeading)
                    .background(Color.componentBackgroundColor)
                    .cornerRadius(11)
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(Color.sectionHeader, lineWidth: 1)
                    )
            }
            .frame(minWidth: 250, maxWidth: .infinity, alignment: .leading)
        }
        .padding()
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
        HStack(alignment: .top) {
            Text("\(label):")
                .font(.body)
                .foregroundColor(Color.secondaryText)
                .frame(minWidth: 100, maxWidth: 150, alignment: .leading)
            
            Text(value)
                .font(.body)
                .foregroundColor(Color.textRegular)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
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
    .frame(width: 897, height: 800)
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
