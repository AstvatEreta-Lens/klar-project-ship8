//
//  ConversationListViewModel.swift
//  KlarProject
//
// Created by Nicholas Tristandi on 28/10/25.


import SwiftUI
import Combine

@MainActor
class ConversationListViewModel: ObservableObject {
    static let shared = ConversationListViewModel()
    
    @Published var selectedConversation: Conversation?
    @Published var humanConversations: [Conversation] = []
    @Published var aiConversations: [Conversation] = []
    @Published var searchText: String = ""
    @Published var selectedFilter: String = "All"
    @Published var toastManager = ToastManager()
    @Published var conversationsMatchingSearch: Set<UUID> = []
    @Published var isMainChatSearchVisible: Bool = true
    @Published var mainChatSearchText: String = ""
    @Published var matchingMessagePreviews: [UUID: String] = [:] // Stores most recent matching message per conversation
    
    
    // Filtered human conversations (by search text)
    var filterHumanConvo: [Conversation] {
        var filtered = humanConversations
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { conversation in
                conversation.name.localizedCaseInsensitiveContains(searchText) ||
                conversation.message.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply button filter (All, Unread, Unresolved)
        filtered = applyButtonFilter(to: filtered)
        
        return filtered
    }
    
    // Filtered AI conversations (by search text and sorted by priority)
    var filterAiConvo: [Conversation] {
        var filtered = aiConversations
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { conversation in
                conversation.name.localizedCaseInsensitiveContains(searchText) ||
                conversation.message.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply button filter
        filtered = applyButtonFilter(to: filtered)
        
        // Sort by priority
        return filtered.sorted { $0.sortPriority < $1.sortPriority }
    }
    
    // Count of unread conversations
    var unreadCount: Int {
        let humanUnread = humanConversations.filter { $0.unreadCount > 0 }.count
        return humanUnread
    }
    
    // Count of unresolved conversations
    var unresolvedCount: Int {
        let aiUnresolved = aiConversations.filter { $0.status != .resolved }.count
        return aiUnresolved + unreadCount
    }
    
    func getPreviewMessage(for conversation: Conversation) -> String {
        if !searchText.isEmpty, let matchingPreview = matchingMessagePreviews[conversation.id] {
            return matchingPreview
        }
        return conversation.message
    }
    // Current user buat satu
 var currentUser: User = User(
        name: "Current User",
        profileImage: "user-avatar",
        email: "user@example.com"
    )
    
    private let apiService = APIService.shared
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        loadConversations()
    }
    
    // MARK: - Data Loading
    
    func loadConversations() {
        Task {
            await fetchConversationsFromAPI()
        }
    }
    
    @MainActor
    private func fetchConversationsFromAPI() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // ✅ Pass clientId ke API
            let clientId = ServiceManager.shared.clientId
            let conversationsData = try await apiService.getConversations(clientId: clientId)
            
            // Convert API data to Conversation models
            var newAiConversations: [Conversation] = []
            var newHumanConversations: [Conversation] = []
            
            for convData in conversationsData {
                // Check if conversation already exists to preserve handlerType and status
                let existingConversation = (aiConversations + humanConversations).first {
                    $0.phoneNumber == convData.phoneNumber
                }
                
                let conversation: Conversation
                if let existing = existingConversation {
                    // Update existing conversation while preserving handlerType and status
                    conversation = Conversation(
                        id: existing.id,
                        name: formatPhoneNumber(convData.phoneNumber),
                        message: convData.lastMessage,
                        time: formatTime(parseTimestamp(convData.timestamp)),
                        profileImage: existing.profileImage,
                        unreadCount: convData.unreadCount,  // ✅ Use unread from API
                        hasWhatsApp: true,
                        phoneNumber: convData.phoneNumber,
                        handlerType: existing.handlerType,
                        status: existing.status,
                        label: existing.label,
                        handledBy: existing.handledBy,
                        handledAt: existing.handledAt,
                        handledDate: parseTimestamp(convData.timestamp),
                        isEvaluated: existing.isEvaluated,
                        evaluatedAt: existing.evaluatedAt,
                        resolvedAt: existing.resolvedAt,
                        seenBy: existing.seenBy,
                        internalNotes: existing.internalNotes
                    )
                } else {
                    // New conversation
                    conversation = convertToConversation(convData)
                }
                
                // Sort into AI or Human conversations based on handlerType
                if conversation.handlerType == .ai {
                    newAiConversations.append(conversation)
                } else {
                    newHumanConversations.append(conversation)
                }
            }
            
            // Update conversations
            if newAiConversations.isEmpty && newHumanConversations.isEmpty && humanConversations.isEmpty && aiConversations.isEmpty {
                return
            } else {
                aiConversations = newAiConversations
                if !newHumanConversations.isEmpty {
                    humanConversations = newHumanConversations
                }
            }
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error loading conversations: \(error)")
        }
        
        isLoading = false
    }
    
    
    // MARK: - Mark as Read
    func markConversationAsRead(_ conversation: Conversation) {
        guard conversation.unreadCount > 0 else { return }
        
        print("📖 [CONVERSATION] Marking as read: \(conversation.name)")
        
        // ✅ Call API to mark as read
        Task {
            let clientId = ServiceManager.shared.clientId
            try? await apiService.markConversationAsRead(
                clientId: clientId,
                phoneNumber: conversation.phoneNumber
            )
        }
        
        // Update local state
        let updatedConversation = Conversation(
            id: conversation.id,
            name: conversation.name,
            message: conversation.message,
            time: conversation.time,
            profileImage: conversation.profileImage,
            unreadCount: 0, // ✅ Reset unread count
            hasWhatsApp: conversation.hasWhatsApp,
            phoneNumber: conversation.phoneNumber,
            handlerType: conversation.handlerType,
            status: conversation.status,
            label: conversation.label,
            handledBy: conversation.handledBy,
            handledAt: conversation.handledAt,
            handledDate: conversation.handledDate,
            isEvaluated: conversation.isEvaluated,
            evaluatedAt: conversation.evaluatedAt,
            resolvedAt: conversation.resolvedAt,
            seenBy: conversation.seenBy,
            internalNotes: conversation.internalNotes
        )
        
        // Update in appropriate list
        if conversation.handlerType == .ai {
            if let index = aiConversations.firstIndex(where: { $0.id == conversation.id }) {
                aiConversations[index] = updatedConversation
            }
        } else {
            if let index = humanConversations.firstIndex(where: { $0.id == conversation.id }) {
                humanConversations[index] = updatedConversation
            }
        }
        
        // Update selected conversation
        if selectedConversation?.id == conversation.id {
            selectedConversation = updatedConversation
        }
    }
    
    // MARK: - Handle New Incoming Message (from webhook)
    func handleNewIncomingMessage(phoneNumber: String, messageText: String) {
        print("\n🔄 [CONVERSATION] Handling new incoming message")
        print("🔄 [CONVERSATION] Phone: \(phoneNumber), Message: \(messageText.prefix(50))")
        
        // Check if conversation exists
        let existingConversation = (aiConversations + humanConversations).first {
            $0.phoneNumber == phoneNumber
        }
        
        let timestamp = Date()
        let timeString = formatTime(timestamp)
        
        if let existing = existingConversation {
            // Update existing conversation
            let updatedConversation: Conversation
            
            if existing.handlerType == .ai {
                let newStatus: statusType? = .open
                
                updatedConversation = Conversation(
                    id: existing.id,
                    name: existing.name,
                    message: messageText,
                    time: timeString,
                    profileImage: existing.profileImage,
                    unreadCount: existing.unreadCount + 1,
                    hasWhatsApp: true,
                    phoneNumber: existing.phoneNumber,
                    handlerType: .ai, // Keep as AI
                    status: newStatus, // Set to .open when customer replies
                    label: existing.label,
                    handledBy: existing.handledBy,
                    handledAt: existing.handledAt,
                    handledDate: timestamp,
                    isEvaluated: existing.isEvaluated,
                    evaluatedAt: existing.evaluatedAt,
                    resolvedAt: nil, // Clear resolvedAt when new message arrives
                    seenBy: existing.seenBy,
                    internalNotes: existing.internalNotes
                )
                
                // Update in AI conversations list
                if let index = aiConversations.firstIndex(where: { $0.id == existing.id }) {
                    aiConversations[index] = updatedConversation
                    // Move to top
                    aiConversations.remove(at: index)
                    aiConversations.insert(updatedConversation, at: 0)
                }
            } else {
                // For human conversations, just update message and unread count
                updatedConversation = Conversation(
                    id: existing.id,
                    name: existing.name,
                    message: messageText,
                    time: timeString,
                    profileImage: existing.profileImage,
                    unreadCount: existing.unreadCount + 1,
                    hasWhatsApp: true,
                    phoneNumber: existing.phoneNumber,
                    handlerType: .human,
                    status: existing.status,
                    label: existing.label,
                    handledBy: existing.handledBy,
                    handledAt: existing.handledAt,
                    handledDate: timestamp,
                    isEvaluated: existing.isEvaluated,
                    evaluatedAt: existing.evaluatedAt,
                    resolvedAt: existing.resolvedAt,
                    seenBy: existing.seenBy,
                    internalNotes: existing.internalNotes
                )
                
                // Update in human conversations list
                if let index = humanConversations.firstIndex(where: { $0.id == existing.id }) {
                    humanConversations[index] = updatedConversation
                    // Move to top
                    humanConversations.remove(at: index)
                    humanConversations.insert(updatedConversation, at: 0)
                }
            }
            
            // Update selected conversation if it's the same
            if selectedConversation?.id == existing.id {
                selectedConversation = updatedConversation
            }
            
        }else {
            // Create new conversation
            let conversationId = UUID()
            let newConversation = Conversation(
                id: conversationId,
                name: formatPhoneNumber(phoneNumber),
                message: messageText,
                time: timeString,
                profileImage: "Photo Profile",
                unreadCount: 1,
                hasWhatsApp: true,
                phoneNumber: phoneNumber,
                handlerType: .ai,
                status: .open,
                label: [],
                handledBy: currentUser,
                handledAt: timeString,
                handledDate: timestamp,
                isEvaluated: false,
                evaluatedAt: nil,
                resolvedAt: nil,
                seenBy: [],
                internalNotes: []
            )
            
            // Add to AI conversations at top
            aiConversations.insert(newConversation, at: 0)
            print("✅ [CONVERSATION] Created new conversation with .open status\n")
            
            // ✅ TAMBAHKAN: Reload dari API untuk sync dengan backend
            Task {
                // Delay sedikit untuk ensure backend sudah simpan
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second
                await fetchConversationsFromAPI()
                print("🔄 [CONVERSATION] Reloaded conversations from API after creating new")
            }
        }
        
    }
    
    // MARK: - Handle Outgoing Message with AI Status
    func handleOutgoingMessage(phoneNumber: String, messageText: String, isUserInitiated: Bool = false, aiStatus: String? = nil) {
        guard !phoneNumber.isEmpty else {
            print("⚠️ [CONVERSATION] Outgoing message without phone number")
            return
        }
        
        guard let existing = (aiConversations + humanConversations).first(where: { $0.phoneNumber == phoneNumber }) else {
            print("⚠️ [CONVERSATION] Outgoing message conversation not found: \(phoneNumber)")
            return
        }
        
        let timestamp = Date()
        let timeString = formatTime(timestamp)
        
        let updatedConversation: Conversation
        
        if existing.handlerType == .ai {
            // PERBAIKAN: Gunakan status dari FastAPI jika tersedia
            var newStatus: statusType? = existing.status
            
            if let aiStatus = aiStatus {
                print("📊 [CONVERSATION] Using AI status: \(aiStatus)")
                switch aiStatus.lowercased() {
                case "open":
                    newStatus = .open
                case "pending":
                    newStatus = .pending
                case "resolved":
                    newStatus = .resolved
                default:
                    newStatus = existing.status
                }
            }
            
            updatedConversation = Conversation(
                id: existing.id,
                name: existing.name,
                message: messageText,
                time: timeString,
                profileImage: existing.profileImage,
                unreadCount: 0,
                hasWhatsApp: existing.hasWhatsApp,
                phoneNumber: existing.phoneNumber,
                handlerType: .ai,
                status: newStatus,  // Gunakan status dari FastAPI
                label: existing.label,
                handledBy: existing.handledBy,
                handledAt: existing.handledAt,
                handledDate: timestamp,
                isEvaluated: existing.isEvaluated,
                evaluatedAt: existing.evaluatedAt,
                resolvedAt: existing.resolvedAt,
                seenBy: existing.seenBy,
                internalNotes: existing.internalNotes
            )
            
            if let index = aiConversations.firstIndex(where: { $0.id == existing.id }) {
                aiConversations[index] = updatedConversation
                aiConversations.remove(at: index)
                aiConversations.insert(updatedConversation, at: 0)
            }
            
        } else {
            // Human handled conversation (tidak berubah)
            updatedConversation = Conversation(
                id: existing.id,
                name: existing.name,
                message: messageText,
                time: timeString,
                profileImage: existing.profileImage,
                unreadCount: 0,
                hasWhatsApp: existing.hasWhatsApp,
                phoneNumber: existing.phoneNumber,
                handlerType: .human,
                status: existing.status,
                label: existing.label,
                handledBy: existing.handledBy,
                handledAt: existing.handledAt,
                handledDate: timestamp,
                isEvaluated: existing.isEvaluated,
                evaluatedAt: existing.evaluatedAt,
                resolvedAt: existing.resolvedAt,
                seenBy: existing.seenBy,
                internalNotes: existing.internalNotes
            )
            
            if let index = humanConversations.firstIndex(where: { $0.id == existing.id }) {
                humanConversations[index] = updatedConversation
                humanConversations.remove(at: index)
                humanConversations.insert(updatedConversation, at: 0)
            }
        }
        
        if selectedConversation?.id == existing.id {
            selectedConversation = updatedConversation
        }
    }
    
    private func convertToConversation(_ data: ConversationData) -> Conversation {
        // Parse timestamp
        let timestamp = parseTimestamp(data.timestamp)
        let timeString = formatTime(timestamp)
        
        // Generate a UUID from phone number for consistent IDs
        let conversationId = UUID(uuidString: data.phoneNumber.replacingOccurrences(of: "[^0-9a-fA-F-]", with: "")) ?? UUID()
        
        // Determine status for new conversations from backend data
        // If there are unread messages, treat conversation as .open (new inbound message)
        let conversationStatus: statusType? = data.unreadCount > 0 ? .open : .pending
        
        return Conversation(
            id: conversationId,
            name: formatPhoneNumber(data.phoneNumber),
            message: data.lastMessage,
            time: timeString,
            profileImage: "Photo Profile",
            unreadCount: data.unreadCount,
            hasWhatsApp: true,
            phoneNumber: data.phoneNumber,
            handlerType: .ai, // Default to AI when first receiving messages
            status: conversationStatus,
            label: [],
            handledBy: currentUser,
            handledAt: timeString,
            handledDate: timestamp,
            isEvaluated: false,
            evaluatedAt: nil,
            resolvedAt: nil, // Only set when explicitly resolved
            seenBy: [],
            internalNotes: []
        )
    }
    
    private func parseTimestamp(_ timestamp: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: timestamp) {
            return date
        }
        
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: timestamp) {
            return date
        }
        
        return Date()
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return formatter.string(from: date)
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        // Format phone number for display
        let cleaned = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if cleaned.count >= 10 {
            let index = cleaned.index(cleaned.startIndex, offsetBy: cleaned.count - 10)
            return String(cleaned[index...])
        }
        return phoneNumber
    }
    
    
    func selectConversation(_ conversation: Conversation) {
        selectedConversation = conversation
        
        markConversationAsRead(conversation)
    }
    
    // MARK: - New Conversation
    
    @MainActor
    func startNewConversation(phoneNumber: String, customName: String = "") async {
        // Check if conversation already exists
        let existingConversation = (humanConversations + aiConversations).first { conv in
            conv.phoneNumber == phoneNumber
        }
        if let existing = existingConversation {
            // Select existing conversation
            selectedConversation = existing
            return
        }
        
        // Create new conversation
        let timestamp = Date()
        let timeString = formatTime(timestamp)
        let conversationId = UUID()
        
        let displayName = customName.isEmpty ? formatPhoneNumber(phoneNumber) : customName
        
        let newConversation = Conversation(
            id: conversationId,
            name: displayName, // ✅ Nama dari input user
            message: "Mulai percakapan",
            time: timeString,
            profileImage: "Photo Profile",
            unreadCount: 0,
            hasWhatsApp: true,
            phoneNumber: phoneNumber,
            handlerType: .human,
            status: nil,
            label: [],
            handledBy: currentUser,
            handledAt: timeString,
            handledDate: timestamp,
            isEvaluated: false,
            evaluatedAt: nil,
            resolvedAt: nil,
            seenBy: [],
            internalNotes: []
        )
        
        // Add to human conversations
        humanConversations.insert(newConversation, at: 0)
        // Select the new conversation
        selectedConversation = newConversation
        
        print("✅ Started new conversation with: \(phoneNumber), name: \(displayName)")
    }
    
    
    // Apply filter from button (All, Unread, Unresolved)
    func applyFilter(_ filter: String) {
        selectedFilter = filter
    }
    
    // Method version of searchConversations
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
    
    // Helper to apply button filter
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
    
    
    func updateConversation(_ updatedConversation: Conversation) {
        // Update in human conversations
        if let index = humanConversations.firstIndex(where: { $0.id == updatedConversation.id }) {
            humanConversations[index] = updatedConversation
            // Update selected conversation if it's the same one
            if selectedConversation?.id == updatedConversation.id {
                selectedConversation = updatedConversation
            }
            print("Update conversation : \(updatedConversation.name)")
            return
        }
        
        // Update in AI conversations
        if let index = aiConversations.firstIndex(where: { $0.id == updatedConversation.id }) {
            aiConversations[index] = updatedConversation
            // Update selected conversation if it's the same one
            if selectedConversation?.id == updatedConversation.id {
                selectedConversation = updatedConversation
            }
            print("Update conversation: \(updatedConversation.name)")
            return
        }
        
        print("Conversation not found: \(updatedConversation.id)")
    }
    
    // MARK: - TakeOver Functionality
    
    // Takes over an AI conversation and converts it to human-handled
    func takeOverConversation() {
        guard let selected = selectedConversation,
              selected.handlerType == .ai,
              (selected.status == .open || selected.status == .pending || selected.status == .resolved) else {
            print("  - handlerType: \(selectedConversation?.handlerType.rawValue ?? "nil")")
            return
        }
        
        print("Take over convo: \(selected.name)")
        
        // Create updated conversation with human handler
        let updatedConversation = Conversation(
            id: selected.id,
            name: selected.name,
            message: selected.message,
            time: getCurrentTime(),
            profileImage: selected.profileImage,
            unreadCount: selected.unreadCount,
            hasWhatsApp: selected.hasWhatsApp,
            phoneNumber: selected.phoneNumber,
            handlerType: .human,
            status: nil,
            label: selected.label,
            handledBy: currentUser,
            handledAt: getCurrentTime(),
            handledDate: Date(),
            isEvaluated: selected.isEvaluated,
            evaluatedAt: selected.evaluatedAt,
            resolvedAt: selected.resolvedAt,
            seenBy: [
                SeenByRecord(
                    user: currentUser,
                    seenAt: getCurrentTime()
                )
            ],
            internalNotes: selected.internalNotes
        )
        
        // Remove from AI list
        if let index = aiConversations.firstIndex(where: { $0.id == selected.id }) {
            aiConversations.remove(at: index)
            print("Ai Convo removed :  \(index))")
        }
        
        // Add to human list (at the top)
        humanConversations.insert(updatedConversation, at: 0)
        print("Added to human convo \(humanConversations.count))")
        
        // Update selected conversation
        selectedConversation = updatedConversation
        print("Updated selected conversation")
        
        // Optional: Add internal note about takeover
        addInternalNote(
            to: updatedConversation.id,
            message: "Conversation taken over from AI by \(currentUser.name)"
        )
    }
    
    // MARK: - Resolve Functionality
    
    // Resolves the current conversation
    func resolveConversation() {
        guard let selected = selectedConversation else {
            print("⚠️ [CONVERSATION] No conversation selected for resolution")
            return
        }
        
        print("\n✅ [CONVERSATION] Marking conversation as resolved: \(selected.name)")
        
        if selected.handlerType == .ai {
            // Update AI conversation to resolved
            if let index = aiConversations.firstIndex(where: { $0.id == selected.id }) {
                let updatedConversation = Conversation(
                    id: selected.id,
                    name: selected.name,
                    message: selected.message,
                    time: getCurrentTime(),
                    profileImage: selected.profileImage,
                    unreadCount: 0,
                    hasWhatsApp: selected.hasWhatsApp,
                    phoneNumber: selected.phoneNumber,
                    handlerType: .ai, // Keep as AI
                    status: .resolved,  // Update status to resolved
                    label: selected.label,
                    handledBy: selected.handledBy,
                    handledAt: selected.handledAt,
                    handledDate: Date(),
                    isEvaluated: false,
                    evaluatedAt: nil,
                    resolvedAt: Date(), // Set resolved timestamp
                    seenBy: selected.seenBy,
                    internalNotes: selected.internalNotes
                )
                
                aiConversations[index] = updatedConversation
                selectedConversation = updatedConversation
                
                addInternalNote(
                    to: updatedConversation.id,
                    message: "Conversation marked as resolved by \(currentUser.name)"
                )
                
                print("✅ [CONVERSATION] AI conversation resolved: \(selected.name)\n")
            }
        } else {
            // For human conversations, mark as resolved and move to AI section
            if let index = humanConversations.firstIndex(where: { $0.id == selected.id }) {
                let updatedConversation = Conversation(
                    id: selected.id,
                    name: selected.name,
                    message: selected.message,
                    time: getCurrentTime(),
                    profileImage: selected.profileImage,
                    unreadCount: 0,
                    hasWhatsApp: selected.hasWhatsApp,
                    phoneNumber: selected.phoneNumber,
                    handlerType: .human, // Move to AI when resolved
                    status: .resolved,  // Update status to resolved
                    label: selected.label,
                    handledBy: selected.handledBy,
                    handledAt: selected.handledAt,
                    handledDate: Date(),
                    isEvaluated: false,
                    evaluatedAt: nil,
                    resolvedAt: Date(),
                    seenBy: selected.seenBy,
                    internalNotes: selected.internalNotes
                )
                
                // Remove from human conversations
                humanConversations.remove(at: index)
                
                // Add to AI conversations
                aiConversations.insert(updatedConversation, at: 0)
                
                selectedConversation = updatedConversation
                
                addInternalNote(
                    to: updatedConversation.id,
                    message: "Conversation marked as resolved by \(currentUser.name)"
                )
                
                print("✅ [CONVERSATION] Human conversation resolved and moved to AI: \(selected.name)\n")
            }
        }
    }
    
    // MARK: Evaluate Functionality
    func evaluateMessage(){
        
    }
    
    
    // MARK: - Internal Notes
    
    // Adds an internal note to a conversation
    private func addInternalNote(to conversationId: UUID, message: String) {
        let note = InternalNote(
            conversationId: conversationId,
            author: currentUser,
            message: message,
            timestamp: Date()
        )
        
        // Update in human conversations
        if let index = humanConversations.firstIndex(where: { $0.id == conversationId }) {
            humanConversations[index].internalNotes.append(note)
        }
        
        // Update in AI conversations
        if let index = aiConversations.firstIndex(where: { $0.id == conversationId }) {
            aiConversations[index].internalNotes.append(note)
        }
        
        // Update selected conversation
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
