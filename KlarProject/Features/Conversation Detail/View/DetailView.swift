//
//  DetailView_MultiLabel.swift
//  KlarProject
//
// Created by Nicholas Tristandi on 05/11/25.
//

import SwiftUI

struct ChatDetailView: View {
    @StateObject private var detailViewModel: DetailViewModel
    @EnvironmentObject var conversationListViewModel: ConversationListViewModel
    @State private var isHovered = false
    @State private var isVisible = false
    
    
    init(conversation: Conversation, onConversationUpdated: ((Conversation) -> Void)? = nil) {
        self._detailViewModel = StateObject(wrappedValue: DetailViewModel(
            conversation: conversation,
            onConversationUpdated: onConversationUpdated
        ))
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    // Profile Image
                    if let conversation = detailViewModel.conversation {
                        Image(conversation.profileImage)
                            .resizable()
                            .frame(width: 59, height: 59)
                            .clipShape(Circle())
                            .padding(.top, 36)
                            .padding(.bottom)
                        
                        // Header - Customer Name & WhatsApp
                        VStack {
                            Text(conversation.name)
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.textRegular)
                            
                            Text(conversation.phoneNumber)
                                .font(.caption2)
                                .foregroundColor(Color.secondaryUsernameText)
                                .padding(.bottom, 3)
                            
                            HStack {
                                Image("whatsapp")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                    .clipShape(Circle())
                                    .foregroundColor(.green)
                                
                                Text("WhatsApp")
                                    .font(.caption)
                                    .foregroundColor(Color.greySecondary)
                            }
                        }
                        .padding(.horizontal, 13)
                        
                        CustomDivider()
                        
                        // Handled By & Status
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Last Handled By")
                                    .font(.caption)
                                    .foregroundColor(Color.textRegular)
                                
                                HandledBySection(
                                    user: conversation.handledBy,
                                    time: conversation.handledAt,
                                    handlerType: conversation.handlerType,
                                    status: conversation.status,
                                    handledDate: conversation.handledDate
                                )
                            }
                            .padding(.leading, 13)
                            Spacer()
                        }
                        .padding(.trailing)
                        
                        CustomDivider()
                        
                        // Multi-Label Section
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Label")
                                    .font(.caption)
                                    .foregroundColor(Color.textRegular)
                                
                                if !conversation.label.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(conversation.label.chunked(into: 3), id: \.first!.text) { chunk in
                                            HStack(spacing: 8) {
                                                ForEach(chunk, id: \.text) { label in
                                                    LabelView(label: label) {
                                                        detailViewModel.deleteLabel(label)
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
                            .padding(.leading, 20)
                            
                            Spacer()
                            
                            AddButton(addLabelImage: "tag.fill") {
                                detailViewModel.showingAddLabel.toggle()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 62, height: 24)
                            .padding(.trailing, 14)
                        }
                        
                        CustomDivider()
                        
                        // Internal Notes & Buttons
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Internal Notes")
                                    .font(.caption)
                                    .foregroundColor(Color.textRegular)
                                    .padding(.leading, 13)
                                
                                Image(systemName: "info.circle.fill")
                                    .font(.caption2)
                                    .foregroundColor(Color.sectionHeader)
                                    .onHover { hovering in
                                        withAnimation(.easeInOut(duration: 0.2)){
                                            isHovered = hovering
                                        }
                                        
                                        if hovering {
                                            withAnimation(.easeInOut){
                                                isVisible = true
                                            }
                                        } else {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                if !isHovered {
                                                    withAnimation(.easeOut(duration : 0.2)){
                                                        isVisible = false
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                
                                
                                
                                    .overlay(alignment : .bottom) {
                                        if isHovered {
                                            BubbleTooltip(text: "Ini adalah informasi tambahan yang muncul saat hover.")
                                                .zIndex(1)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .offset(y:-10)
                                                .transition(.opacity.combined(with: .scale))
                                        }
                                    }
                                
                            }
                            
                            InternalNotesView(
                                conversationId: conversation.id,
                                currentUser: User(name: "Current Admin", profileImage: "", email: "admin@example.com")
                            )
                            .padding(.horizontal, 16)
                            
                            HStack {
                                Text("AI Summary")
                                    .font(.caption)
                                    .foregroundColor(Color.textRegular)
                                    .padding(.leading, 13)
                                
                                Image(systemName: "info.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(Color.textRegular)
                            }
                            
                            AISummaryView(
                                conversationId: UUID(),
                                messages: []
                            )
                            .padding(.leading)
                            
                            Spacer()
                            
                            EvaluateButton(evaluateAction: evaluateMessage)
                                .frame(minWidth: 307, maxWidth: .infinity, maxHeight: 36)
                                .padding(.horizontal)
                                .padding(.bottom)
                            
                            if shouldShowMarkResolvedButton(for: conversation) {
                                ResolveButton(resolveAction: handleResolve)
                                    .frame(minWidth: 307, maxWidth: .infinity, maxHeight: 36)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 334, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            
            if detailViewModel.showingAddLabel {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            detailViewModel.showingAddLabel = false
                        }
                    }
                
                VStack {
                    Spacer()
                    
                    if let conversation = detailViewModel.conversation {
                        AddLabelView(
                            viewModel: AddLabelViewModel(existingLabels: conversation.label),
                            onLabelToggle: { label in
                                detailViewModel.toggleLabel(label)
                            }
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                    }
                    
                    Spacer()
                }
            }
        }
        .onChange(of: conversationListViewModel.selectedConversation?.id) { oldID, newID in
            if let _ = newID, let updated = conversationListViewModel.selectedConversation {
                detailViewModel.updateConversation(updated)
            }
        }
        .onChange(of: conversationListViewModel.selectedConversation?.handlerType) { oldType, newType in
            if let _ = newType, let updated = conversationListViewModel.selectedConversation {
                detailViewModel.updateConversation(updated)
            }
        }
    }
    
    private func shouldShowMarkResolvedButton(for conversation: Conversation) -> Bool {
        return conversation.handlerType == .human
    }
    
    private func handleResolve() {
        conversationListViewModel.resolveConversation()
    }
    
    private func evaluateMessage() {
        conversationListViewModel.evaluateMessage()
    }
}

#Preview {
    ChatDetailView(
        conversation: Conversation.humanDummyData[0],
        onConversationUpdated: { updatedConversation in
            print("Conversation updated: \(updatedConversation.name)")
        }
    )
    .environmentObject(ConversationListViewModel())
    .frame(width: 334)
}

