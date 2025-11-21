//
//  AISummaryService.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import Foundation

// MARK: - Models
struct AISummary: Identifiable, Codable {
    let id: UUID
    let conversationId: UUID
    let summary: String
    let generatedAt: Date
    let messageCount: Int // Number of messages summarized
    
    init(
        id: UUID = UUID(),
        conversationId: UUID,
        summary: String,
        generatedAt: Date = Date(),
        messageCount: Int
    ) {
        self.id = id
        self.conversationId = conversationId
        self.summary = summary
        self.generatedAt = generatedAt
        self.messageCount = messageCount
    }
}

// MARK: - Protocol
protocol AISummaryServiceProtocol {
    // Generate a new summary from conversation messages
    func generateSummary(conversationId: UUID, messages: [Message]) async throws -> AISummary
    
    // Fetch existing summary for a conversation
    func fetchSummary(conversationId: UUID) async throws -> AISummary?
    
    // Regenerate summary (useful when new messages are added)
    func regenerateSummary(conversationId: UUID, messages: [Message]) async throws -> AISummary
    
    // Delete summary
    func deleteSummary(conversationId: UUID) async throws
}

// MARK: - Mock Service (for development), nanti ubah pakai yang bener
class MockAISummaryService: AISummaryServiceProtocol {
    // Storage: [ConversationID: Summary]
    private var storage: [UUID: AISummary] = [:]
    
    // Shared instance
    static let shared = MockAISummaryService()
    
    private init() {}
    
    func generateSummary(conversationId: UUID, messages: [Message]) async throws -> AISummary {
        // Simulate LLM API processing time
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Generate mock summary based on message count
        let mockSummary = generateMockSummary(from: messages)
        
        let summary = AISummary(
            conversationId: conversationId,
            summary: mockSummary,
            messageCount: messages.count
        )
        
        // Save to storage
        storage[conversationId] = summary
        
        print("AI Summary generated for conversation: \(conversationId)")
        print("Messages summarized: \(messages.count)")
        
        return summary
    }
    
    func fetchSummary(conversationId: UUID) async throws -> AISummary? {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        return storage[conversationId]
    }
    
    func regenerateSummary(conversationId: UUID, messages: [Message]) async throws -> AISummary {
        // Delete old summary and generate new one
        storage.removeValue(forKey: conversationId)
        return try await generateSummary(conversationId: conversationId, messages: messages)
    }
    
    func deleteSummary(conversationId: UUID) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        
        storage.removeValue(forKey: conversationId)
        print("Summary deleted for conversation: \(conversationId)")
    }
    
    // MARK: - Helper
    private func generateMockSummary(from messages: [Message]) -> String {
        // Mock summary generation based on message count and content
        let messageCount = messages.count
        
        if messageCount == 0 {
            return "No messages to summarize."
        }
        
        // Count customer vs agent messages
        let customerMessages = messages.filter { $0.isFromCustomer }.count
        let agentMessages = messages.filter { $0.isFromAgent }.count
        
        // Extract key topics from first few messages
        let firstMessages = messages.prefix(3).map { $0.content }.joined(separator: " ")
        let containsPricing = firstMessages.lowercased().contains("harga") || firstMessages.lowercased().contains("pricing")
        let containsTechnical = firstMessages.lowercased().contains("rusak") || firstMessages.lowercased().contains("error") || firstMessages.lowercased().contains("service")
        
        // Generate contextual summary
        if messageCount < 5 {
            return "Percakapan singkat dengan \(messageCount) pesan. Customer menghubungi untuk pertanyaan awal dan agent merespons dengan informasi dasar."
        } else if containsTechnical {
            return "Customer melaporkan masalah teknis. Agent melakukan troubleshooting dan memberikan solusi. Total \(messageCount) pesan (\(customerMessages) dari customer, \(agentMessages) dari agent). Status: sedang ditangani."
        } else if containsPricing {
            return "Customer menanyakan informasi harga dan detail produk. Agent memberikan penawaran lengkap dan opsi pembayaran. Diskusi mencakup \(messageCount) pesan dengan detail spesifikasi dan perbandingan harga."
        } else {
            return "Percakapan dengan \(messageCount) pesan (\(customerMessages) dari customer, \(agentMessages) dari agent). Customer bertanya tentang produk/layanan. Agent memberikan informasi lengkap dan dukungan. Beberapa topik dibahas termasuk detail produk dan langkah selanjutnya."
        }
    }
}

// MARK: - Real API Service (OpenAI/Anthropic/etc)
class APIAISummaryService: AISummaryServiceProtocol {
    private let apiKey: String
    private let baseURL: String
    private let model: String
    
    // Configure based on your LLM provider
    // Example: OpenAI, Anthropic Claude, Google Gemini, etc.
    init(
        apiKey: String,
        baseURL: String = "https://api.openai.com/v1", // Default to OpenAI
        model: String = "gpt-4o-mini" // Or claude-3-haiku, gemini-pro, etc.
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.model = model
    }
    
    func generateSummary(conversationId: UUID, messages: [Message]) async throws -> AISummary {
        // Prepare messages for LLM
        let messagesToSummarize = formatMessagesForLLM(messages)
        
        // Create the prompt
        let systemPrompt = """
        You are a helpful assistant that summarizes customer service conversations in Bahasa Indonesia.
        Provide a concise but comprehensive summary of the conversation below.
        Include:
        - Topik utama yang dibahas
        - Pertanyaan kunci dari customer
        - Solusi atau informasi yang diberikan agent
        - Action items atau follow-up yang diperlukan
        - Status percakapan (resolved, pending, escalated, dll)
        
        Keep the summary professional, factual, and in Bahasa Indonesia.
        Maximum 150 words.
        """
        
        // Make API request
        let summary = try await callLLMAPI(
            systemPrompt: systemPrompt,
            messages: messagesToSummarize
        )
        
        let aiSummary = AISummary(
            conversationId: conversationId,
            summary: summary,
            messageCount: messages.count
        )
        
        // Optionally save to backend
        try await saveSummaryToBackend(aiSummary)
        
        return aiSummary
    }
    
    func fetchSummary(conversationId: UUID) async throws -> AISummary? {
        // Fetch from your backend API
        let url = URL(string: "\(baseURL)/conversations/\(conversationId)/summary")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 404 {
            return nil // No summary exists
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let summary = try JSONDecoder().decode(AISummary.self, from: data)
        return summary
    }
    
    func regenerateSummary(conversationId: UUID, messages: [Message]) async throws -> AISummary {
        // Delete old and generate new
        try await deleteSummary(conversationId: conversationId)
        return try await generateSummary(conversationId: conversationId, messages: messages)
    }
    
    func deleteSummary(conversationId: UUID) async throws {
        let url = URL(string: "\(baseURL)/conversations/\(conversationId)/summary")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 || httpResponse.statusCode == 204 else {
            throw APIError.deleteFailed
        }
    }
    
    // MARK: - Private Helpers
    
    private func formatMessagesForLLM(_ messages: [Message]) -> String {
        // Format messages into a readable text for the LLM
        return messages.map { message in
            let sender = message.isFromCustomer ? "Customer" : (message.isFromAgent ? "Agent" : "System")
            let time = message.formattedTime
            return "[\(time)] \(sender): \(message.content)"
        }.joined(separator: "\n")
    }
    
    private func callLLMAPI(systemPrompt: String, messages: String) async throws -> String {
        // Example for OpenAI API
        let url = URL(string: "\(baseURL)/chat/completions")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": "Summarize this conversation:\n\n\(messages)"]
            ],
            "temperature": 0.3,
            "max_tokens": 500
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.llmApiFailed
        }
        
        // Parse response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw APIError.invalidLLMResponse
        }
        
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func saveSummaryToBackend(_ summary: AISummary) async throws {
        // Save to your backend for caching
        let url = URL(string: "\(baseURL)/conversations/\(summary.conversationId)/summary")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(summary)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.saveFailed
        }
    }
}

// MARK: - Errors
enum APIError: LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int)
    case deleteFailed
    case llmApiFailed
    case invalidLLMResponse
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .deleteFailed:
            return "Failed to delete summary"
        case .llmApiFailed:
            return "LLM API request failed"
        case .invalidLLMResponse:
            return "Could not parse LLM response"
        case .saveFailed:
            return "Failed to save summary"
        }
    }
}
