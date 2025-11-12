//
//  ConversationListViewModel.swift
//  KlarProject
//
// Created by Nicholas Tristandi on 28/10/25.
//

import SwiftUI
import Combine

@MainActor
class ConversationListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedConversation: Conversation?
    @Published var humanConversations: [Conversation] = []
    @Published var aiConversations: [Conversation] = []
    @Published var searchText: String = ""
    @Published var selectedFilter: String = "All"
    @Published var isConnected: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let apiService = WhatsAppAPIService.shared
    private let webhookService = WebhookService()
    private var clientId: String
    private var cancellables = Set<AnyCancellable>()
    
    private var currentUser: User = User(
        name: "Current User",
        profileImage: "user-avatar",
        email: "user@example.com"
    )
    
    // MARK: - Computed Properties
    var filterHumanConvo: [Conversation] {
        var filtered = humanConversations
        
        if !searchText.isEmpty {
            filtered = filtered.filter { conversation in
                conversation.name.localizedCaseInsensitiveContains(searchText) ||
                conversation.message.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filtered = applyButtonFilter(to: filtered)
        return filtered
    }
    
    var filterAiConvo: [Conversation] {
        var filtered = aiConversations
        
        if !searchText.isEmpty {
            filtered = filtered.filter { conversation in
                conversation.name.localizedCaseInsensitiveContains(searchText) ||
                conversation.message.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filtered = applyButtonFilter(to: filtered)
        return filtered.sorted { $0.sortPriority < $1.sortPriority }
    }
    
    var unreadCount: Int {
        let humanUnread = humanConversations.filter { $0.unreadCount > 0 }.count
        let aiUnread = aiConversations.filter { $0.unreadCount > 0 }.count
        return humanUnread + aiUnread
    }
    
    var unresolvedCount: Int {
        let aiUnresolved = aiConversations.filter { $0.status != .resolved }.count
        let humanUnresolved = humanConversations.filter { $0.status != .resolved }.count
        return aiUnresolved + humanUnresolved
    }
    
    // MARK: - Initialization
    init(config: WhatsAppConfig? = nil) {
        self.clientId = UUID().uuidString
        
        setupWebhookHandlers()
        loadConversations()
        
        if let config = config, config.isValid {
            Task {
                await connect(with: config)
            }
        }
    }
    
    // MARK: - Connection Management
    func connect(with config: WhatsAppConfig) async {
        do {
            apiService.configure(baseURL: config.webhookServerURL)
            try webhookService.start()
            
            let callbackUrl = "http://localhost:\(config.localWebhookPort)/webhook"
            let success = try await apiService.registerClient(
                clientId: clientId,
                callbackUrl: callbackUrl
            )
            
            if success {
                isConnected = true
                print("✅ Successfully connected to WhatsApp API")
                await fetchConversations()
            }
        } catch {
            errorMessage = "Failed to connect: \(error.localizedDescription)"
            print("❌ Connection error: \(error)")
        }
    }
    
    func disconnect() async {
        do {
            try await apiService.unregisterClient(clientId: clientId)
            webhookService.stop()
            isConnected = false
            print("✅ Disconnected from WhatsApp API")
        } catch {
            print("❌ Disconnect error: \(error)")
        }
    }
    
    // MARK: - Webhook Setup
    private func setupWebhookHandlers() {
        webhookService.onMessageReceived = { [weak self] messageData in
            Task { @MainActor in
                await self?.handleIncomingMessage(messageData)
            }
        }
        
        webhookService.onStatusUpdate = { [weak self] statusData in
            Task { @MainActor in
                await self?.handleStatusUpdate(statusData)
            }
        }
    }
    
    // MARK: - Message Handling
    private func handleIncomingMessage(_ messageData: WebhookMessageData) async {
        print("📨 Incoming message from: \(messageData.from)")
        
        guard let textBody = messageData.text?.body else {
            print("⚠️ No text body in message")
            return
        }
        
        let phoneNumber = messageData.from
        var conversation = findConversation(by: phoneNumber)
        
        if conversation == nil {
            conversation = Conversation(
                name: phoneNumber,
                phoneNumber: phoneNumber,
                handlerType: .ai,
                status: .pending
            )
        }
        
        guard var conv = conversation else { return }
        
        let message = Message(
            whatsappMessageId: messageData.messageId,
            conversationId: conv.id,
            phoneNumber: phoneNumber,
            content: textBody,
            timestamp: Date(),
            isFromUser: true,
            status: .delivered
        )
        
        conv.addMessage(message)
        updateConversation(conv)
        
        if selectedConversation?.id == conv.id {
            selectedConversation = conv
        }
    }
    
    private func handleStatusUpdate(_ statusData: StatusUpdateData) async {
        print("📊 Status update for message: \(statusData.messageId) - \(statusData.status)")
        
        for i in 0..<humanConversations.count {
            for j in 0..<humanConversations[i].messages.count {
                if humanConversations[i].messages[j].whatsappMessageId == statusData.messageId {
                    let oldMessage = humanConversations[i].messages[j]
                    let newStatus = MessageStatus(rawValue: statusData.status) ?? .sent
                    
                    let updatedMessage = Message(
                        id: oldMessage.id,
                        whatsappMessageId: oldMessage.whatsappMessageId,
                        conversationId: oldMessage.conversationId,
                        phoneNumber: oldMessage.phoneNumber,
                        content: oldMessage.content,
                        timestamp: oldMessage.timestamp,
                        isFromUser: oldMessage.isFromUser,
                        status: newStatus,
                        type: oldMessage.type
                    )
                    
                    humanConversations[i].messages[j] = updatedMessage
                    
                    if selectedConversation?.id == humanConversations[i].id {
                        selectedConversation = humanConversations[i]
                    }
                    return
                }
            }
        }
        
        for i in 0..<aiConversations.count {
            for j in 0..<aiConversations[i].messages.count {
                if aiConversations[i].messages[j].whatsappMessageId == statusData.messageId {
                    let oldMessage = aiConversations[i].messages[j]
                    let newStatus = MessageStatus(rawValue: statusData.status) ?? .sent
                    
                    let updatedMessage = Message(
                        id: oldMessage.id,
                        whatsappMessageId: oldMessage.whatsappMessageId,
                        conversationId: oldMessage.conversationId,
                        phoneNumber: oldMessage.phoneNumber,
                        content: oldMessage.content,
                        timestamp: oldMessage.timestamp,
                        isFromUser: oldMessage.isFromUser,
                        status: newStatus,
                        type: oldMessage.type
                    )
                    
                    aiConversations[i].messages[j] = updatedMessage
                    
                    if selectedConversation?.id == aiConversations[i].id {
                        selectedConversation = aiConversations[i]
                    }
                    return
                }
            }
        }
    }
    
    // MARK: - Send Message
    func sendMessage(_ text: String, to conversation: Conversation) async {
        guard !text.isEmpty else { return }
        
        // Normalize phone number untuk WhatsApp API
        let normalizedPhone = PhoneNumberUtility.normalize(conversation.phoneNumber)
        
        print("=== SEND MESSAGE DEBUG ===")
        print("📤 Sending message to: \(conversation.phoneNumber)")
        print("📱 Normalized to: \(normalizedPhone)")
        print("💬 Message: \(text)")
        print("🔑 ClientID: \(clientId)")
        /*rint("🌐 API URL: \(apiService.baseURL)")*/
        print("========================")
        
        // Create optimistic message
        let message = Message(
            conversationId: conversation.id,
            phoneNumber: normalizedPhone,
            content: text,
            timestamp: Date(),
            isFromUser: false,
            status: .sending
        )
        
        // Update UI immediately
        var updatedConv = conversation
        updatedConv.addMessage(message)
        updateConversation(updatedConv)
        
        if selectedConversation?.id == conversation.id {
            selectedConversation = updatedConv
        }
        
        // Send to API
        do {
            let response = try await apiService.sendMessage(
                to: normalizedPhone,  // Use normalized phone
                text: text,
                clientId: clientId
            )
            
            if response.success, let messageId = response.messageId {
                print("✅ Message sent successfully: \(messageId)")
                
                // Update message dengan WhatsApp message ID
                if let index = updatedConv.messages.firstIndex(where: { $0.id == message.id }) {
                    let sentMessage = Message(
                        id: message.id,
                        whatsappMessageId: messageId,
                        conversationId: message.conversationId,
                        phoneNumber: normalizedPhone,
                        content: message.content,
                        timestamp: message.timestamp,
                        isFromUser: false,
                        status: .sent
                    )
                    updatedConv.messages[index] = sentMessage
                    updateConversation(updatedConv)
                    
                    if selectedConversation?.id == conversation.id {
                        selectedConversation = updatedConv
                    }
                }
            }
        } catch {
            print("❌ Failed to send message: \(error)")
            print("📝 Error details: \(error.localizedDescription)")
            errorMessage = "Failed to send message: \(error.localizedDescription)"
            
            // Update message status to failed
            if let index = updatedConv.messages.firstIndex(where: { $0.id == message.id }) {
                let failedMessage = Message(
                    id: message.id,
                    whatsappMessageId: message.whatsappMessageId,
                    conversationId: message.conversationId,
                    phoneNumber: normalizedPhone,
                    content: message.content,
                    timestamp: message.timestamp,
                    isFromUser: false,
                    status: .failed
                )
                updatedConv.messages[index] = failedMessage
                updateConversation(updatedConv)
                
                if selectedConversation?.id == conversation.id {
                    selectedConversation = updatedConv
                }
            }
        }
    }
    
    // MARK: - Data Loading
    func loadConversations() {
        humanConversations = Conversation.humanDummyData
        aiConversations = Conversation.aiDummyData
    }
    
    func fetchConversations() async {
        do {
            let conversationsData = try await apiService.getConversations()
            
            var newConversations: [Conversation] = []
            
            for convData in conversationsData {
                let conversation = Conversation(
                    name: convData.name ?? convData.phoneNumber,
                    message: convData.lastMessage ?? "",
                    time: convData.timestamp ?? "",
                    phoneNumber: convData.phoneNumber,
                    handlerType: .ai,
                    status: .pending
                )
                newConversations.append(conversation)
            }
            
            aiConversations = newConversations
            
            print("✅ Loaded \(newConversations.count) conversations")
        } catch {
            print("❌ Failed to fetch conversations: \(error)")
        }
    }
    
    func fetchMessages(for conversation: Conversation) async {
        do {
            let messagesData = try await apiService.getMessages(for: conversation.phoneNumber)
            
            var updatedConv = conversation
            updatedConv.messages = messagesData.map { msgData in
                Message(
                    whatsappMessageId: msgData.id,
                    conversationId: conversation.id,
                    phoneNumber: msgData.from,
                    content: msgData.text,
                    timestamp: Date(),
                    isFromUser: msgData.from == conversation.phoneNumber
                )
            }
            
            updateConversation(updatedConv)
            
            if selectedConversation?.id == conversation.id {
                selectedConversation = updatedConv
            }
            
            print("✅ Loaded \(messagesData.count) messages for \(conversation.name)")
        } catch {
            print("❌ Failed to fetch messages: \(error)")
        }
    }
    
    // MARK: - Conversation Management
    func selectConversation(_ conversation: Conversation) {
        selectedConversation = conversation
        
        var updatedConv = conversation
        updatedConv.markAsRead()
        updateConversation(updatedConv)
        
        if conversation.messages.isEmpty {
            Task {
                await fetchMessages(for: conversation)
            }
        }
    }
    
    func applyFilter(_ filter: String) {
        selectedFilter = filter
    }
    
    func searchConversations() -> [Conversation] {
        let allConversations = humanConversations + aiConversations
        if searchText.isEmpty {
            return allConversations
        }
        return allConversations.filter { conversation in
            conversation.name.localizedCaseInsensitiveContains(searchText) ||
            conversation.message.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func applyButtonFilter(to conversations: [Conversation]) -> [Conversation] {
        switch selectedFilter {
        case "Unread":
            return conversations.filter { $0.unreadCount > 0 }
        case "Unresolved":
            return conversations.filter { conversation in
                if conversation.handlerType == .ai {
                    return conversation.status != .resolved
                }
                return true
            }
        default:
            return conversations
        }
    }
    
    // MARK: - Helper Functions
    private func findConversation(by phoneNumber: String) -> Conversation? {
        if let conv = humanConversations.first(where: { $0.phoneNumber == phoneNumber }) {
            return conv
        }
        if let conv = aiConversations.first(where: { $0.phoneNumber == phoneNumber }) {
            return conv
        }
        return nil
    }
    
    private func updateConversation(_ conversation: Conversation) {
        if conversation.handlerType == .human {
            if let index = humanConversations.firstIndex(where: { $0.id == conversation.id }) {
                humanConversations[index] = conversation
            } else {
                humanConversations.insert(conversation, at: 0)
            }
        } else {
            if let index = aiConversations.firstIndex(where: { $0.id == conversation.id }) {
                aiConversations[index] = conversation
            } else {
                aiConversations.insert(conversation, at: 0)
            }
        }
    }
    
    // MARK: - TakeOver & Resolve
    func takeOverConversation() {
        guard let selected = selectedConversation,
              selected.handlerType == .ai,
              (selected.status == .pending || selected.status == .open) else {
            return
        }
        
        print("Taking over conversation: \(selected.name)")
        
        var updatedConversation = selected
        updatedConversation.handlerType = .human
        updatedConversation.status = nil
        updatedConversation.handledBy = currentUser
        updatedConversation.handledAt = getCurrentTime()
        updatedConversation.seenBy = [
            SeenByRecord(user: currentUser, seenAt: getCurrentTime())
        ]
        
        if let index = aiConversations.firstIndex(where: { $0.id == selected.id }) {
            aiConversations.remove(at: index)
        }
        
        humanConversations.insert(updatedConversation, at: 0)
        selectedConversation = updatedConversation
        
        addInternalNote(
            to: updatedConversation.id,
            message: "Conversation taken over from AI by \(currentUser.name)"
        )
    }
    
    func resolveConversation() {
        guard let selected = selectedConversation else { return }
        
        var updatedConversation = selected
        updatedConversation.status = .resolved
        updatedConversation.unreadCount = 0
        
        if selected.handlerType == .human {
            if let index = humanConversations.firstIndex(where: { $0.id == selected.id }) {
                humanConversations.remove(at: index)
            }
            aiConversations.insert(updatedConversation, at: 0)
        } else {
            if let index = aiConversations.firstIndex(where: { $0.id == selected.id }) {
                aiConversations[index] = updatedConversation
            }
        }
        
        selectedConversation = updatedConversation
        
        addInternalNote(
            to: updatedConversation.id,
            message: "Conversation marked as resolved by \(currentUser.name)"
        )
    }
    
    // MARK: - Internal Notes
    private func addInternalNote(to conversationId: UUID, message: String) {
        let note = InternalNote(
            conversationId: conversationId,
            author: currentUser,
            message: message,
            timestamp: Date()
        )
        
        if let index = humanConversations.firstIndex(where: { $0.id == conversationId }) {
            humanConversations[index].internalNotes.append(note)
        }
        
        if let index = aiConversations.firstIndex(where: { $0.id == conversationId }) {
            aiConversations[index].internalNotes.append(note)
        }
        
        if selectedConversation?.id == conversationId {
            selectedConversation?.internalNotes.append(note)
        }
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return formatter.string(from: Date())
    }
}
