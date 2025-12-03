//if let profile = currentProfile {
//    VStack(alignment: .leading, spacing: 16) {
//        HStack {
//            Text("Profile")
//                .foregroundColor(Color.primaryText)
//            Spacer()
//            profilePicker
//        }
//        
//        
//private var profilePicker: some View {
//    Menu {
//        ForEach(viewModel.userProfiles.indices, id: \.self) { index in
//            Button {
//                selectedProfileIndex = index
//            } label: {
//                Text(viewModel.userProfiles[index].username)
//            }
//        }
//    } label: {
//        HStack(spacing: 8) {
//            Text(currentProfile?.username ?? "Select user")
//                .foregroundColor(Color.primaryText)
//            Image(systemName: "chevron.down")
//                .font(.caption)
//        }
//        .padding(.horizontal, 12)
//        .padding(.vertical, 8)
//        .background(
//            Capsule()
//                .fill(Color.sectionHeader.opacity(0.15))
//        )
//    }
//}
//
//    VStack(spacing: 12) {
//        Text("No account data found.")
//            .foregroundColor(.secondary)
//        Button("Reload") {
//            selectedProfileIndex = 0
//        }
//    }
//    .frame(maxWidth: .infinity, alignment: .center)


// ChatViewModel - Dump


//
// ChatViewModel.swift
//import Foundation
//import SwiftUI
//import Combine
//
//@MainActor
//class ChatViewModel: ObservableObject {
//    // MARK: - Published Properties
//    @Published var conversations: [Conversation] = []
//    @Published var currentMessages: [Message] = []
//    @Published var selectedConversation: Conversation?
//    @Published var isLoading = false
//    @Published var isConnected = false
//    @Published var errorMessage: String?
//    @Published var config: WhatsAppConfig
//    @Published var uploadStatus: String = "No file uploaded yet"
//    @Published var selectedFileURL: URL?
//    
//    
//    // MARK: - Private Properties
//    private let apiService = APIService.shared
//    private let webhookService = WebhookService()
//    private let clientId: String
//    private var cancellables = Set<AnyCancellable>()
//    
//    // MARK: - Initialization
//    init(config: WhatsAppConfig = .default) {
//        self.config = config
//        self.clientId = "macos-\(UUID().uuidString)"
//        
//        setupWebhookService()
//        
//        // Use unowned self to prevent retain cycle
//        Task { [weak self] in
//            await self?.initialize()
//        }
//    }
//    
//    deinit {
//        // Detached task to avoid capturing self in deinit
//        let clientId = self.clientId
//        let apiService = self.apiService
//        let webhookService = self.webhookService
//        
//        Task.detached {
//           webhookService.stop()
//            
//            do {
//                try await apiService.unregisterClient(clientId: clientId)
//                print("👋 Unregistered client: \(clientId)")
//            } catch {
//                print("❌ Error unregistering: \(error)")
//            }
//        }
//    }
//    
//    // MARK: - Initialization & Cleanup
//    func initialize() async {
//        apiService.configure(baseURL: config.webhookServerURL)
//        
//        do {
//            try webhookService.start()
//            
//            let success = try await apiService.registerClient(
//                clientId: clientId,
//                callbackUrl: "http://localhost:8080/webhook"
//            )
//            
//            if success {
//                isConnected = true
//                await loadConversations()
//            }
//        } catch {
//            errorMessage = "Failed to connect: \(error.localizedDescription)"
//            isConnected = false
//        }
//    }
//    
//    // No longer needed - handled in deinit directly
//    // func cleanup() async { ... }
//    
//    // MARK: - Webhook Setup
//    private func setupWebhookService() {
//        webhookService.onMessageReceived = { [weak self] messageData in
//            print("🎯 ViewModel received message callback")
//            Task { @MainActor in
//                await self?.handleIncomingMessage(messageData)
//            }
//        }
//        
//        webhookService.onStatusUpdate = { [weak self] statusData in
//            print("🎯 ViewModel received status callback")
//            Task { @MainActor in
//                await self?.handleStatusUpdate(statusData)
//            }
//        }
//    }
//    
//    //MARK: - uploadfile
//    func uploadFile(_ url: URL) {
//        selectedFileURL = url
//        uploadStatus = "Uploading \(url.lastPathComponent)..."
//        
//        // simulasi upload ke server
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//        self.uploadStatus = "✅ Uploaded: \(url.lastPathComponent)"
//        }
//    }
//    
//    // MARK: - Load Data
//    func loadConversations() async {
//        isLoading = true
//        
//        do {
//            let conversationData = try await apiService.getConversations()
//            
//            conversations = conversationData.map { data in
//                Conversation(
//                    phoneNumber: data.phoneNumber,
//                    lastMessage: data.lastMessage,
//                    timestamp: parseDate(data.timestamp),
//                    unreadCount: data.unreadCount,
//                    
//                )
//            }.sorted { $0.timestamp > $1.timestamp }
//            
//        } catch {
//            errorMessage = "Failed to load conversations: \(error.localizedDescription)"
//        }
//        
//        isLoading = false
//    }
//    
//    func loadMessages(for phoneNumber: String) async {
//        isLoading = true
//        
//        do {
//            let messagesData = try await apiService.getMessages(for: phoneNumber)
//            
//            // Use Set to track unique message IDs
//            var uniqueMessages: [String: Message] = [:]
//            
//            for data in messagesData {
//                let messageId = data.messageId ?? UUID().uuidString
//                
//                // Skip if already exist
//                if uniqueMessages[messageId] != nil {
//                    print("⚠️ Skipping duplicate message: \(messageId)")
//                    continue
//                }
//                
//                let message = Message(
//                    id: messageId,
//                    text: data.text,
//                    isFromMe: data.isFromMe,
//                    phoneNumber: data.from ?? data.to ?? phoneNumber,
//                    timestamp: parseDate(data.timestamp),
//                    status: mapStatus(data.status)
//                )
//                
//                uniqueMessages[messageId] = message
//            }
//            
//            // Sort by timestamp
//            currentMessages = uniqueMessages.values.sorted { $0.timestamp < $1.timestamp }
//            
//            print("📥 Loaded \(currentMessages.count) unique messages")
//            
//        } catch {
//            errorMessage = "Failed to load messages: \(error.localizedDescription)"
//        }
//        
//        isLoading = false
//    }
//    
//    // MARK: - Send Message
//    func sendMessage(to phoneNumber: String, text: String) async {
//        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
//        
//        // Generate temporary ID
//        let tempId = "temp-\(UUID().uuidString)"
//        
//        // Add temporary message
//        let tempMessage = Message(
//            id: tempId,
//            text: text,
//            isFromMe: true,
//            phoneNumber: phoneNumber,
//            status: .sending
//        )
//        currentMessages.append(tempMessage)
//        
//        // Update conversation
//        updateOrCreateConversation(phoneNumber: phoneNumber, lastMessage: text)
//        
//        do {
//            let response = try await apiService.sendMessage(
//                to: phoneNumber,
//                text: text,
//                clientId: clientId
//            )
//            
//            if response.success, let messageId = response.messageId {
//                // Replace temporary message with real one
//                if let index = currentMessages.firstIndex(where: { $0.id == tempId }) {
//                    currentMessages[index] = Message(
//                        id: messageId,
//                        text: text,
//                        isFromMe: true,
//                        phoneNumber: phoneNumber,
//                        timestamp: Date(),
//                        status: .sent
//                    )
//                    print("✅ Message sent with ID: \(messageId)")
//                }
//            } else {
//                throw APIError.sendMessageFailed(response.error ?? "Unknown error")
//            }
//            
//        } catch {
//            // Mark message as failed
//            if let index = currentMessages.firstIndex(where: { $0.id == tempId }) {
//                currentMessages[index] = Message(
//                    id: tempId,
//                    text: text,
//                    isFromMe: true,
//                    phoneNumber: phoneNumber,
//                    timestamp: Date(),
//                    status: .failed
//                )
//            }
//            
//            errorMessage = "Failed to send message: \(error.localizedDescription)"
//        }
//    }
//    
//    // MARK: - Handle Incoming Messages
//    private func handleIncomingMessage(_ messageData: WebhookMessageData) async {
//        guard let from = messageData.from else {
//            print("⚠️ No sender in message data")
//            return
//        }
//        
//        print("📩 Processing incoming message from: \(from)")
//        print("📝 Message text: \(messageData.text ?? "nil")")
//        print("🆔 Message ID: \(messageData.messageId ?? "nil")")
//        
//        // Check if message already exists (prevent duplicates)
//        let messageId = messageData.messageId ?? UUID().uuidString
//        if currentMessages.contains(where: { $0.id == messageId }) {
//            print("⚠️ Message already exists, skipping: \(messageId)")
//            return
//        }
//        
//        let message = Message(
//            id: messageId,
//            text: messageData.text ?? "[Unknown message]",
//            isFromMe: false,
//            phoneNumber: from,
//            timestamp: parseDate(messageData.timestamp)
//        )
//        
//        // Add to current messages if viewing this conversation
//        if selectedConversation?.phoneNumber == from {
//            print("✅ Adding message to current conversation")
//            currentMessages.append(message)
//        } else {
//            print("ℹ️ Message for different conversation: \(from)")
//        }
//        
//        // Update conversation
//        updateOrCreateConversation(
//            phoneNumber: from,
//            lastMessage: messageData.text ?? "[Unknown message]",
//            incrementUnread: selectedConversation?.phoneNumber != from
//        )
//        
//        print("✅ Message processed successfully")
//    }
//    
//    private func handleStatusUpdate(_ statusData: StatusUpdateData) async {
//        // Update message status
//        if let index = currentMessages.firstIndex(where: { $0.id == statusData.messageId }) {
//            currentMessages[index].status = mapStatus(statusData.status)
//            print("✅ Updated message status: \(statusData.status)")
//        } else {
//            print("ℹ️ Status update for unknown message: \(statusData.messageId)")
//        }
//    }
//    
//    // MARK: - Conversation Management
//    func selectConversation(_ conversation: Conversation) {
//        selectedConversation = conversation
//        
//        // Clear unread count
//        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
//            conversations[index].unreadCount = 0
//        }
//        
//        Task {
//            await loadMessages(for: conversation.phoneNumber)
//        }
//    }
//    
//    func createNewConversation(phoneNumber: String) {
//        let cleanedNumber = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
//        let conversation = Conversation(phoneNumber: cleanedNumber)
//        conversations.insert(conversation, at: 0)
//        selectedConversation = conversation
//        currentMessages = []
//    }
//    
//    private func updateOrCreateConversation(
//        phoneNumber: String,
//        lastMessage: String,
//        incrementUnread: Bool = false
//    ) {
//        if let index = conversations.firstIndex(where: { $0.phoneNumber == phoneNumber }) {
//            conversations[index].lastMessage = lastMessage
//            conversations[index].timestamp = Date()
//            if incrementUnread {
//                conversations[index].unreadCount += 1
//            }
//            
//            // Move to top
//            let conversation = conversations.remove(at: index)
//            conversations.insert(conversation, at: 0)
//        } else {
//            let newConversation = Conversation(
//                phoneNumber: phoneNumber,
//                lastMessage: lastMessage,
//                unreadCount: incrementUnread ? 1 : 0
//            )
//            conversations.insert(newConversation, at: 0)
//        }
//    }
//    
//    // MARK: - Helpers
//    private func mapStatus(_ status: String?) -> Message.MessageStatus {
//        guard let status = status else { return .sent }
//        
//        switch status.lowercased() {
//        case "sending":
//            return .sending
//        case "sent":
//            return .sent
//        case "delivered":
//            return .delivered
//        case "read":
//            return .read
//        case "failed":
//            return .failed
//        default:
//            return .sent
//        }
//    }
//    
//    private func parseDate(_ dateString: String) -> Date {
//        let formatter = ISO8601DateFormatter()
//        return formatter.date(from: dateString) ?? Date()
//    }
//    
//    func formatPhoneNumber(_ phoneNumber: String) -> String {
//        // Format phone number for display
//        let cleaned = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
//        
//        if cleaned.hasPrefix("62") && cleaned.count > 2 {
//            let prefix = "+62"
//            let number = String(cleaned.dropFirst(2))
//            return "\(prefix) \(number)"
//        }
//        
//        return phoneNumber
//    }
//}
//
