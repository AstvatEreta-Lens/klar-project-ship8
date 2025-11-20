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
    @EnvironmentObject var evaluationViewModel: EvaluationViewModel
    @State private var isHovered1 = false
    @State private var isHovered2 = false
    @State private var isVisible = false
    
    
    init(conversation: Conversation, onConversationUpdated: ((Conversation) -> Void)? = nil) {
        self._detailViewModel = StateObject(wrappedValue: DetailViewModel(
            conversation: conversation,
            onConversationUpdated: onConversationUpdated
        ))
    }
    
    var body: some View {
        ZStack {
            VStack(alignment : .leading) {
                    // Profile Image
                    if let conversation = detailViewModel.conversation {
                        
                        // Header - Customer Name & WhatsApp
                        HStack(alignment : .center){
                            Image(conversation.profileImage)
                                .resizable()
                                .frame(width: 59, height: 59)
                                .clipShape(Circle())
                                .padding(.top, 14)
                                .padding(.bottom)
                            
                            VStack(alignment : .leading) {
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
                                    .foregroundColor(Color.textRegular)
                                    .onHover { hovering in
                                        withAnimation(.easeInOut(duration: 0.2)){
                                            isHovered1 = hovering
                                        }
                                        
                                        if hovering {
                                            withAnimation(.easeInOut){
                                                isVisible = true
                                            }
                                        } else {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                if !isHovered1 {
                                                    withAnimation(.easeOut(duration : 0.2)){
                                                        isVisible = false
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                
                                    .overlay(alignment : .bottom) {
                                        if isHovered1 {
                                            BubbleTooltip(text: NSLocalizedString("Add private notes for this conversation. Only your team can see these notes", comment : ""))
                                                .zIndex(1)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .offset(y:-10)
                                                .transition(.opacity.combined(with: .scale))
                                        }
                                    }
                                
                            }

                            InternalNotesView(
                                conversationId: conversation.id,
                                currentUser: conversationListViewModel.currentUser
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
                                    .onHover { hovering in
                                        withAnimation(.easeInOut(duration: 0.2)){
                                            isHovered2 = hovering
                                        }
                                        
                                        if hovering {
                                            withAnimation(.easeInOut){
                                                isVisible = true
                                            }
                                        } else {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                if !isHovered2 {
                                                    withAnimation(.easeOut(duration : 0.2)){
                                                        isVisible = false
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                
                                    .overlay(alignment : .bottom) {
                                        if isHovered2 {
                                            BubbleTooltip(text: NSLocalizedString("This summary is generated by AI to help you review the conversation faster. \nWe suggest you review the AI result. \nOutput may vary based on chat length and knowledge base", comment : ""))
                                                .zIndex(1)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .offset(y:-10)
                                                .transition(.opacity.combined(with: .scale))
                                        }
                                    }
                            }
                            
                            AISummaryView(
                                conversationId: UUID(),
                                messages: []
                            )
                            .padding(.leading)
                            
                            Spacer()
                            
                            EvaluateButton(conversation: conversation, evaluateAction: evaluateMessage)
                                .frame(minWidth: 307, maxWidth: .infinity, maxHeight: 36)
                                .padding(.horizontal)
                                .padding(.bottom, 13)
                            
                            if shouldShowMarkResolvedButton(for: conversation) {
                                ResolveButton(resolveAction: handleResolve)
                                    .frame(minWidth: 307, maxWidth: .infinity, maxHeight: 36)
                                    .padding(.horizontal)
                                    .padding(.bottom, 13)
                            }
                    }
                }
            }
            .frame(minWidth: 334, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .toast(manager: detailViewModel.toastManager)
            
            if detailViewModel.showingAddLabel {
                ZStack(alignment: .topTrailing) {
                    Color.clear
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                detailViewModel.showingAddLabel = false
                            }
                        }

                    VStack(alignment: .trailing, spacing: 0) {
                        // Spacer untuk posisi tombol Add
                        Spacer()
                            .frame(height: 220) // Jarak dari top ke bawah tombol Add
                            .allowsHitTesting(false)

                        if let conversation = detailViewModel.conversation {
                            AddLabelView(
                                viewModel: AddLabelViewModel(existingLabels: conversation.label),
                                onLabelToggle: { label in
                                    detailViewModel.toggleLabel(label)
                                }
                            )
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .padding(.trailing, 14)
                            .padding(.top, 8)
                        }

                        Spacer()
                            .allowsHitTesting(false)
                    }
                }
            }
        }
        // SwiftUI view modifier that lets you run code in response to changes in a value.
        // keep the detail panel sync with the currently selected conversation
        .onChange(of: conversationListViewModel.selectedConversation?.id) { oldID, newID in
            if let _ = newID, let updated = conversationListViewModel.selectedConversation {
                detailViewModel.updateConversation(updated)
            }
        }
        
        // handler type -> human / ai
        .onChange(of: conversationListViewModel.selectedConversation?.handlerType) { oldType, newType in
            if let _ = newType, let updated = conversationListViewModel.selectedConversation {
                detailViewModel.updateConversation(updated)
            }
        }
        .onChange(of: conversationListViewModel.selectedConversation?.status) { oldStatus, newStatus in
            if let _ = newStatus, let updated = conversationListViewModel.selectedConversation {
                detailViewModel.updateConversation(updated)
            }
        }
    }
    
    private func shouldShowMarkResolvedButton(for conversation: Conversation) -> Bool {
        return conversation.handlerType == .human && conversation.status != .resolved
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
    .environmentObject(ConversationListViewModel.shared)
    .frame(width: 334)
}
