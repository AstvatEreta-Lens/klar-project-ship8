//
//  MainChatViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//
import SwiftUI
import Combine

@MainActor
class MainChatViewModel: ObservableObject {
    // ✅ SOLUTION: Make messages @Published and update it directly
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isSending: Bool = false
    @Published var searchText: String = ""
    @Published var refreshTrigger: Bool = false

    
    private var allMessagesCache: [ChatMessage] = []  // Cache for search
    private var hasLoadedMessages = false
    private let apiService = APIService.shared
    private var cancellables = Set<AnyCancellable>()
    private var clientId: String {
        ServiceManager.shared.clientId
    }
    
    private var phoneNumber: String = ""
    
    var currentPhoneNumber: String {
        phoneNumber
    }

    // ✅ NEW: Update messages when search text changes
    func searchMessages() {
        print("🔍 [SEARCH] Searching for: '\(searchText)'")
        
        guard !searchText.isEmpty else {
            messages = allMessagesCache  // ✅ Direct assignment triggers UI update
            print("🔍 [SEARCH] Search cleared, showing all \(allMessagesCache.count) messages")
            return
        }
        
        let searchLower = searchText.lowercased()
        
        // Filter and directly assign to messages
        messages = allMessagesCache.filter { message in
            message.text.lowercased().contains(searchLower)
        }
        
        print("🔍 [SEARCH] Found \(messages.count) matching messages")
    }
    
    // ✅ COMPUTED: For compatibility with AISummaryView
    var filteredMessages: [ChatMessage] {
        messages
    }
 
    func loadMessages(for phoneNumber: String) async {
        guard !phoneNumber.isEmpty else {
            print("⚠️ [CHAT] Empty phone number")
            return
        }
        
        if self.phoneNumber == phoneNumber && !allMessagesCache.isEmpty {
            print("ℹ️ [CHAT] Messages already loaded for \(phoneNumber)")
            return
        }
        
        self.phoneNumber = phoneNumber
        isLoading = true
        errorMessage = nil
        
        print("\n📥 [MESSAGE] Loading messages for: \(phoneNumber)")
        
        do {
            let apiMessages = try await apiService.getMessages(for: phoneNumber)
            
            print("✅ [CHAT] Loaded \(apiMessages.count) messages from API")
            
            var mergedMessages = allMessagesCache
            
            for apiMessage in apiMessages {
                let messageId = apiMessage.messageId ?? UUID().uuidString
                
                let exists = mergedMessages.contains { $0.messageId == messageId }
                
                if !exists {
                    let timestamp = parseTimestamp(apiMessage.timestamp)
                    
                    let isUserMessage: Bool
                    if apiMessage.isFromMe == true {
                        isUserMessage = true
                    } else if apiMessage.from == phoneNumber {
                        isUserMessage = false
                    } else {
                        isUserMessage = false
                    }
                    
                    let status: MessageStatus = isUserMessage ? .sent : .read
                    
                    let chatMessage = ChatMessage(
                        id: messageId,
                        text: apiMessage.text ?? "",
                        isFromUser: isUserMessage,
                        timestamp: timestamp,
                        messageId: messageId,
                        status: status
                    )
                    
                    mergedMessages.append(chatMessage)
                }
            }
            
            let sortedMessages = mergedMessages.sorted { $0.timestamp < $1.timestamp }
            
            print("📊 [CHAT] Total messages after merge: \(sortedMessages.count)")
            
            // ✅ Direct assignment to @Published properties
            self.allMessagesCache = sortedMessages
            self.messages = sortedMessages  // ✅ This triggers UI update!
            self.hasLoadedMessages = true
            self.isLoading = false
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ [MESSAGE] Error loading messages: \(error)")
            self.isLoading = false
        }
    }

    func sendMessage(_ text: String) async {
        guard !phoneNumber.isEmpty, !text.isEmpty else { return }
        
        isSending = true
        errorMessage = nil
        
        let tempId = UUID().uuidString
        let tempMessage = ChatMessage(
            id: tempId,
            text: text,
            isFromUser: true,
            timestamp: Date(),
            messageId: nil,
            status: .sending
        )
        
        // ✅ Direct append and assignment
        allMessagesCache.append(tempMessage)
        messages = allMessagesCache  // ✅ Trigger UI update
        
        do {
            let response = try await apiService.sendMessage(
                to: phoneNumber,
                message: text,
                type: "text",
                clientId: clientId
            )
            
            allMessagesCache.removeAll { $0.id == tempId }
            
            if let messageData = response.message {
                let newMessage = ChatMessage(
                    id: messageData.messageId ?? UUID().uuidString,
                    text: messageData.text ?? text,
                    isFromUser: true,
                    timestamp: Date(),
                    messageId: messageData.messageId,
                    status: .sent
                )
                allMessagesCache.append(newMessage)
            } else {
                let confirmedMessage = ChatMessage(
                    id: response.messageId ?? UUID().uuidString,
                    text: text,
                    isFromUser: true,
                    timestamp: Date(),
                    messageId: response.messageId,
                    status: .sent
                )
                allMessagesCache.append(confirmedMessage)
            }
            
            allMessagesCache.sort { $0.timestamp < $1.timestamp }
            messages = allMessagesCache  // ✅ Trigger UI update
            
        } catch {
            if let index = allMessagesCache.firstIndex(where: { $0.id == tempId }) {
                allMessagesCache[index].status = .failed
                messages = allMessagesCache  // ✅ Trigger UI update
            }
            errorMessage = error.localizedDescription
        }
        
        isSending = false
    }
    
    func handleIncomingMessage(_ webhookData: WebhookMessageData) {
        print("\n📨 [WEBHOOK] Processing incoming message")
        
        guard let messageText = webhookData.text, !messageText.isEmpty else {
            print("⚠️ [WEBHOOK] Empty message text, skipping")
            return
        }
        
        if let messageId = webhookData.messageId {
            let isDuplicate = allMessagesCache.contains { $0.messageId == messageId }
            if isDuplicate {
                print("⚠️ [WEBHOOK] Duplicate message detected, skipping: \(messageId)")
                return
            }
        }
        
        let isForCurrentConversation = (webhookData.from == phoneNumber) ||
                                       (webhookData.to == phoneNumber)
        
        guard isForCurrentConversation else {
            print("ℹ️ [WEBHOOK] Message not for current conversation, skipping")
            print("   Current phone: \(phoneNumber)")
            print("   Message from: \(webhookData.from ?? "nil")")
            print("   Message to: \(webhookData.to ?? "nil")")
            return
        }
        
        let isUserMessage: Bool
        if webhookData.isAIReply == true {
            isUserMessage = true
            print("🤖 [WEBHOOK] AI reply detected - will show on RIGHT")
        } else if webhookData.isFromMe == true {
            isUserMessage = true
            print("👤 [WEBHOOK] Manual user message - will show on RIGHT")
        } else if webhookData.from == phoneNumber {
            isUserMessage = false
            print("📱 [WEBHOOK] Customer message - will show on LEFT")
        } else {
            isUserMessage = false
            print("❓ [WEBHOOK] Unknown message type - defaulting to LEFT")
        }
        
        let timestamp = parseTimestamp(webhookData.timestamp ?? "")
        
        let initialStatus: MessageStatus
        if isUserMessage {
            initialStatus = .sent
        } else {
            initialStatus = .read
        }
        
        let newMessage = ChatMessage(
            id: webhookData.messageId ?? UUID().uuidString,
            text: messageText,
            isFromUser: isUserMessage,
            timestamp: timestamp,
            messageId: webhookData.messageId,
            status: initialStatus
        )
        
        // ✅ NUCLEAR FIX: Multiple ways to trigger UI update
        
        // Method 1: Update cache
        allMessagesCache.append(newMessage)
        allMessagesCache.sort { $0.timestamp < $1.timestamp }
        
        // Method 2: Create new array (force SwiftUI to detect change)
        messages = allMessagesCache.map { $0 }
        
        // Method 3: Toggle dummy property
        refreshTrigger.toggle()
        
        // Method 4: Explicit objectWillChange
        objectWillChange.send()
        
        print("✅ [WEBHOOK] Message added to chat view")
        print("   - Text: \(messageText)")
        print("   - From User: \(isUserMessage)")
        print("   - Status: \(initialStatus)")
        print("   - Total in cache: \(allMessagesCache.count)")
        print("   - Total in messages: \(messages.count)")
        print("   - Refresh trigger: \(refreshTrigger)")
    }

    
    func clearSearch() {
        searchText = ""
        messages = allMessagesCache  // ✅ Reset to all messages
    }
    
    func highlightedText(for message: ChatMessage) -> AttributedString {
        guard !searchText.isEmpty else {
            return AttributedString(message.text)
        }
        
        var attributedString = AttributedString(message.text)
        let searchLower = searchText.lowercased()
        let textLower = message.text.lowercased()
        
        var searchStartIndex = textLower.startIndex
        
        while let range = textLower.range(of: searchLower, range: searchStartIndex..<textLower.endIndex) {
            let lowerBound = AttributedString.Index(range.lowerBound, within: attributedString)
            let upperBound = AttributedString.Index(range.upperBound, within: attributedString)
            
            if let lowerBound = lowerBound, let upperBound = upperBound {
                let attributedRange = lowerBound..<upperBound
                
                attributedString[attributedRange].backgroundColor = .yellow
                attributedString[attributedRange].foregroundColor = .black
            }
            
            searchStartIndex = range.upperBound
        }
        
        return attributedString
    }
    
    func handleStatusUpdate(_ statusData: StatusUpdateData) {
        if let index = allMessagesCache.firstIndex(where: { $0.messageId == statusData.messageId }) {
            allMessagesCache[index].status = MessageStatus(rawValue: statusData.status.lowercased()) ?? .sent
            messages = allMessagesCache  // ✅ Trigger UI update
            print("✅ Updated message status to: \(statusData.status)")
        } else {
            print("⚠️ Message not found for status update: \(statusData.messageId)")
        }
    }
    
    func clearMessages() {
        allMessagesCache.removeAll()
        messages.removeAll()  // ✅ Trigger UI update
        phoneNumber = ""
        hasLoadedMessages = false
        print("🗑️ [CHAT] Messages cleared")
    }
    
    private func parseTimestamp(_ timestamp: String?) -> Date {
        guard let timestamp = timestamp, !timestamp.isEmpty else {
            return Date()
        }
   
        if let unixTimestamp = Double(timestamp) {
            return Date(timeIntervalSince1970: unixTimestamp)
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: timestamp) {
            return date
        }
        
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: timestamp) {
            return date
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd"
        ]
        
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: timestamp) {
                return date
            }
        }
        
        return Date()
    }
}
