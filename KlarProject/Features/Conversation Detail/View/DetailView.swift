//
//  DetailView_MultiLabel.swift
//  KlarProject
//
// Created by Nicholas Tristandi on 05/11/25.
//

import SwiftUI

struct ChatDetailView: View {
    @State private var conversation: Conversation
    @State private var showingAddLabel = false
    @State private var showingAddCollaborator = false
    
    // Callback untuk update conversation ke parent view
    var onConversationUpdated: ((Conversation) -> Void)?
    
    init(conversation: Conversation, onConversationUpdated: ((Conversation) -> Void)? = nil) {
        self._conversation = State(initialValue: conversation)
        self.onConversationUpdated = onConversationUpdated
    }
    
    var body: some View {
        VStack {
            VStack {
                Image(conversation.profileImage)
                    .resizable()
                    .frame(width: 59, height: 59)
                    .clipShape(Circle())
                    .padding(.top, 36)
                    .padding(.bottom)
                
                // Header - Customer Name & WhatsApp
                VStack {
                    Text(conversation.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.blackSecondary)
                    
                    Text(conversation.phoneNumber)
                        .font(.system(size: 12))
                        .underline(true)
                        .foregroundColor(Color.greySecondary)
                        .padding(.bottom, 2)
                    
                    HStack {
                        Image("whatsapp")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .clipShape(Circle())
                            .foregroundColor(.green)
                        
                        Text("WhatsApp")
                            .font(.system(size: 12))
                            .foregroundColor(Color.greySecondary)
                    }
                }
                .padding(.horizontal, 13)
                
                CustomDivider()
                    .padding(.top, -3)
                
                // Handled By & Status
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Last Handled By")
                            .font(.caption)
                            .foregroundColor(Color.primaryUsernameText)
                        
                        HandledBySection(
                            user: conversation.handledBy,
                            time: conversation.handledAt,
                            handlerType: conversation.handlerType,
                            status: conversation.status
                        )
                    }
                    .padding(.leading, 13)
                    Spacer()
                }
                .padding(.trailing)
                
                CustomDivider()
                
                // Multi-Label Section with Chunked Display
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Label")
                            .font(.caption)
                            .foregroundColor(Color.primaryUsernameText)
                        
                        // Display Multiple Labels (Chunked into rows of 3)
                        if !conversation.label.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(conversation.label.chunked(into: 3), id: \.first!.text) { chunk in
                                    HStack(spacing: 8) {
                                        ForEach(chunk, id: \.text) { label in
                                            LabelView(label: label) {
                                                deleteLabel(label)
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        } else {
                            Text("No labels added")
                                .font(.caption)
                                .foregroundColor(Color.primaryUsernameText)
                        }
                    }
                    .padding(.leading, 12)
                    
                    Spacer()
                    
                    // Add/Edit Button
                    AddButton(addLabelImage: "tag.fill") {
                        showingAddLabel = true
                    }
                    .padding(.trailing, 14)
                }
                
                CustomDivider()
                
                // Internal Notes
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("INTERNAL NOTES")
                            .font(.system(size: 12))
                            .foregroundColor(Color.black)
                            .padding(.leading, 13)
                        
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color.black)
                    }
                    
                    // Space untuk internal notes chat
                    InternalNotesView(
                        conversationId: conversation.id,
                        currentUser: User(name: "Current Admin", profileImage: "", email: "admin@example.com")
                    )
                    .padding(.horizontal, 16)
                    
                    HStack {
                        Text("SUMMARY")
                            .font(.system(size: 12))
                            .foregroundColor(Color.black)
                            .padding(.leading, 13)
                        
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color.black)
                    }
                    
                    Summary(generateAISummary: {})
                        .padding(.leading, 14)
                        .padding(.bottom)
                }
            }
        }
        .frame(minWidth: 334, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
        
        // change with overlay later
        .popover(isPresented: $showingAddLabel, arrowEdge: .trailing) {
            AddLabelView(
                viewModel: AddLabelViewModel(existingLabels: conversation.label),
                onAddLabels: { selectedLabels in
                    updateLabels(selectedLabels)
                }
            )
            .presentationCompactAdaptation(.popover)
        }
    }
    
    // Label Management
    
    // Update labels in the conversation (replaces all existing labels)
    private func updateLabels(_ newLabels: [LabelType]) {
        conversation = conversation.updatinglabel(newLabels)
        onConversationUpdated?(conversation)
        
        print("Labels updated: \(newLabels.map { $0.text }.joined(separator: ", "))")
    }
    
    // Delete a specific label from the conversation
    private func deleteLabel(_ label: LabelType) {
        var updatedLabels = conversation.label
        updatedLabels.removeAll { $0 == label }
        
        conversation = conversation.updatinglabel(updatedLabels)
        onConversationUpdated?(conversation)
        
        print("Label deleted: \(label.text)")
    }
}

#Preview{
    ChatDetailView(
        conversation: Conversation.humanDummyData[0],
        onConversationUpdated: { updatedConversation in
            print("Conversation updated: \(updatedConversation.name)")
            print("Labels: \(updatedConversation.label.map { $0.text }.joined(separator: ", "))")
        }
    )
    .frame(width: 334)
}
