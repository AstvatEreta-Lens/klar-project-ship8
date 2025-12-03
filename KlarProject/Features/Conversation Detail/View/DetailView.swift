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
    @EnvironmentObject var chatViewModel: MainChatViewModel
    @State private var isHovered1 = false
    @State private var isHovered2 = false
    @State private var isVisible = false
    
    init(
        conversation: Conversation,
        onConversationUpdated: ((Conversation) -> Void)? = nil
    ) {
        self._detailViewModel = StateObject(wrappedValue: DetailViewModel(
            conversation: conversation,
            onConversationUpdated: onConversationUpdated
        ))
    }
    
    var body: some View {
        ZStack {
            mainContent
            
            if detailViewModel.showingAddLabel {
                addLabelOverlay
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
        .onChange(of: conversationListViewModel.selectedConversation?.status) { oldStatus, newStatus in
            if let _ = newStatus, let updated = conversationListViewModel.selectedConversation {
                detailViewModel.updateConversation(updated)
            }
        }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        VStack(alignment: .leading) {
            if let conversation = detailViewModel.conversation {
                profileHeader(conversation)
                CustomDivider()
                handledBySection(conversation)
                CustomDivider()
                labelSection(conversation)
                CustomDivider()
                notesAndSummarySection(conversation)
            }
        }
        .frame(minWidth: 334, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
//        .toast(manager: detailViewModel.toastManager)
    }
    
    // MARK: - Profile Header
    private func profileHeader(_ conversation: Conversation) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(conversation.profileImage)
                .resizable()
                .frame(width: 59, height: 59)
                .clipShape(Circle())
                .padding(.top, 14)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.textRegular)
                    Spacer()
                }
                
                Text(conversation.phoneNumber)
                    .font(.body)
                    .foregroundColor(Color(hex: "#4D4D4D"))
                
                HStack {
                    Image("whatsapp")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .clipShape(Circle())
                        .foregroundColor(.green)
                    
                    Text("WhatsApp")
                        .font(.callout)
                        .foregroundColor(Color(hex: "#545454"))
                }
            }
            .padding(.top, 14)
            
            Spacer()
            
            
        }
        .padding(.horizontal, 13)
        .padding(.bottom, 12)
    }
    
    // MARK: - Handled By Section
    private func handledBySection(_ conversation: Conversation) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Last Handled By")
                    .font(.callout)
                    .foregroundColor(Color.black)
                
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
    }
    
    // MARK: - Label Section
    private func labelSection(_ conversation: Conversation) -> some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Label")
                    .font(.callout)
                    .foregroundColor(Color.black)
                
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
    }
    
    // MARK: - Notes and Summary Section
 func notesAndSummarySection(_ conversation: Conversation) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            internalNotesHeader
            
            InternalNotesView(
                conversationId: conversation.id,
                currentUser: conversationListViewModel.currentUser
            )
            .padding(.horizontal, 16)
            
            aiSummaryHeader
            
            AISummaryView(
                conversationId: conversation.id,
                messages: chatViewModel.messages  // ✅ Use real messages
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
    
    // MARK: - Internal Notes Header
    private var internalNotesHeader: some View {
        HStack {
            Text("Internal Notes")
                .font(.callout)
                .foregroundColor(Color.black)
                .padding(.leading, 13)
            
            Image(systemName: "info.circle.fill")
                .font(.caption2)
                .foregroundColor(Color.textRegular)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isHovered1 = hovering
                    }
                    
                    if hovering {
                        withAnimation(.easeInOut) {
                            isVisible = true
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if !isHovered1 {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    isVisible = false
                                }
                            }
                        }
                    }
                }
                .overlay(alignment: .bottom) {
                    if isHovered1 {
                        BubbleTooltip(text: NSLocalizedString("Add private notes for this conversation. Only your team can see these notes", comment: ""))
                            .zIndex(1)
                            .fixedSize(horizontal: false, vertical: true)
                            .offset(y: -10)
                            .transition(.opacity.combined(with: .scale))
                    }
                }
        }
    }
    
    // MARK: - AI Summary Header
    private var aiSummaryHeader: some View {
        HStack {
            Text("AI Summary")
                .font(.callout)
                .foregroundColor(Color.black)
                .padding(.leading, 13)
            
            Image(systemName: "info.circle.fill")
                .font(.caption)
                .foregroundColor(Color.textRegular)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isHovered2 = hovering
                    }
                    
                    if hovering {
                        withAnimation(.easeInOut) {
                            isVisible = true
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if !isHovered2 {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    isVisible = false
                                }
                            }
                        }
                    }
                }
                .overlay(alignment: .bottom) {
                    if isHovered2 {
                        BubbleTooltip(text: NSLocalizedString("This summary is generated by AI to help you review the conversation faster. \nWe suggest you review the AI result. \nOutput may vary based on chat length and knowledge base", comment: ""))
                            .zIndex(1)
                            .fixedSize(horizontal: false, vertical: true)
                            .offset(y: -10)
                            .transition(.opacity.combined(with: .scale))
                    }
                }
        }
    }
    
    // MARK: - Add Label Overlay
    private var addLabelOverlay: some View {
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
                Spacer()
                    .frame(height: 220)
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
    
    // MARK: - Helper Functions
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
