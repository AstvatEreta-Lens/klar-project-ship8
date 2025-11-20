////
////  ConversationService.swift
////  KlarProject
////
////  Created for Backend Integration
////
//
//import Foundation
//
//// MARK: - Protocol
//
//protocol ConversationServiceProtocol {
//    // Fetch all conversations
//    func fetchConversations() async throws -> [Conversation]
//
//    // Fetch single conversation
//    func fetchConversation(id: UUID) async throws -> Conversation
//
//    // Resolve conversation
//    func resolveConversation(id: UUID) async throws -> Conversation
//
//    // Take over AI conversation
//    func takeOverConversation(id: UUID, userId: UUID) async throws -> Conversation
//
//    // Update conversation labels
//    func updateLabels(conversationId: UUID, labels: [LabelType]) async throws -> Conversation
//}
//
//// MARK: - API Service (Production)
//
//class APIConversationService: ConversationServiceProtocol {
//    private let baseURL: String
//    private let apiKey: String
//
//    init(baseURL: String = "https://your-api.com/api/v1", apiKey: String) {
//        self.baseURL = baseURL
//        self.apiKey = apiKey
//    }
//
//    func fetchConversations() async throws -> [Conversation] {
//        let url = URL(string: "\(baseURL)/conversations")!
//        var request = URLRequest(url: url)
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw ServiceError.httpError
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return try decoder.decode([Conversation].self, from: data)
//    }
//
//    func fetchConversation(id: UUID) async throws -> Conversation {
//        let url = URL(string: "\(baseURL)/conversations/\(id.uuidString)")!
//        var request = URLRequest(url: url)
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw ServiceError.httpError
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return try decoder.decode(Conversation.self, from: data)
//    }
//
//    func resolveConversation(id: UUID) async throws -> Conversation {
//        let url = URL(string: "\(baseURL)/conversations/\(id.uuidString)/resolve")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw ServiceError.httpError
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return try decoder.decode(Conversation.self, from: data)
//    }
//
//    func takeOverConversation(id: UUID, userId: UUID) async throws -> Conversation {
//        let url = URL(string: "\(baseURL)/conversations/\(id.uuidString)/takeover")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body = ["user_id": userId.uuidString]
//        request.httpBody = try JSONSerialization.data(withJSONObject: body)
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw ServiceError.httpError
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return try decoder.decode(Conversation.self, from: data)
//    }
//
//    func updateLabels(conversationId: UUID, labels: [LabelType]) async throws -> Conversation {
//        let url = URL(string: "\(baseURL)/conversations/\(conversationId.uuidString)/labels")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let labelStrings = labels.map { $0.rawValue }
//        let body = ["labels": labelStrings]
//        request.httpBody = try JSONSerialization.data(withJSONObject: body)
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw ServiceError.httpError
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return try decoder.decode(Conversation.self, from: data)
//    }
//}
//
//// MARK: - Mock Service (Development/Testing)
//
//class MockConversationService: ConversationServiceProtocol {
//    // Use dummy data during development
//    private var conversations: [Conversation] = Conversation.humanDummyData + Conversation.aiDummyData
//
//    func fetchConversations() async throws -> [Conversation] {
//        try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
//        return conversations
//    }
//
//    func fetchConversation(id: UUID) async throws -> Conversation {
//        try await Task.sleep(nanoseconds: 300_000_000)
//
//        guard let conversation = conversations.first(where: { $0.id == id }) else {
//            throw ServiceError.notFound
//        }
//        return conversation
//    }
//
//    func resolveConversation(id: UUID) async throws -> Conversation {
//        try await Task.sleep(nanoseconds: 500_000_000)
//
//        guard let index = conversations.firstIndex(where: { $0.id == id }) else {
//            throw ServiceError.notFound
//        }
//
//        // Update conversation
//        var updated = conversations[index]
//        updated = Conversation(
//            id: updated.id,
//            name: updated.name,
//            message: updated.message,
//            time: updated.time,
//            profileImage: updated.profileImage,
//            unreadCount: 0,
//            hasWhatsApp: updated.hasWhatsApp,
//            phoneNumber: updated.phoneNumber,
//            handlerType: updated.handlerType,
//            status: .resolved,
//            label: updated.label,
//            handledBy: updated.handledBy,
//            handledAt: updated.handledAt,
//            handledDate: Date(),
//            isEvaluated: false,
//            evaluatedAt: nil,
//            resolvedAt: Date(),
//            seenBy: updated.seenBy,
//            internalNotes: updated.internalNotes
//        )
//
//        conversations[index] = updated
//        return updated
//    }
//
//    func takeOverConversation(id: UUID, userId: UUID) async throws -> Conversation {
//        try await Task.sleep(nanoseconds: 500_000_000)
//
//        guard let index = conversations.firstIndex(where: { $0.id == id }) else {
//            throw ServiceError.notFound
//        }
//
//        // Convert to human handler
//        var updated = conversations[index]
//        updated = Conversation(
//            id: updated.id,
//            name: updated.name,
//            message: updated.message,
//            time: updated.time,
//            profileImage: updated.profileImage,
//            unreadCount: updated.unreadCount,
//            hasWhatsApp: updated.hasWhatsApp,
//            phoneNumber: updated.phoneNumber,
//            handlerType: .human,
//            status: nil,
//            label: updated.label,
//            handledBy: User(name: "Current User", profileImage: "", email: "user@example.com"),
//            handledAt: updated.handledAt,
//            handledDate: Date(),
//            isEvaluated: updated.isEvaluated,
//            evaluatedAt: updated.evaluatedAt,
//            resolvedAt: updated.resolvedAt,
//            seenBy: updated.seenBy,
//            internalNotes: updated.internalNotes
//        )
//
//        conversations[index] = updated
//        return updated
//    }
//
//    func updateLabels(conversationId: UUID, labels: [LabelType]) async throws -> Conversation {
//        try await Task.sleep(nanoseconds: 300_000_000)
//
//        guard let index = conversations.firstIndex(where: { $0.id == conversationId }) else {
//            throw ServiceError.notFound
//        }
//
//        var updated = conversations[index]
//        updated = Conversation(
//            id: updated.id,
//            name: updated.name,
//            message: updated.message,
//            time: updated.time,
//            profileImage: updated.profileImage,
//            unreadCount: updated.unreadCount,
//            hasWhatsApp: updated.hasWhatsApp,
//            phoneNumber: updated.phoneNumber,
//            handlerType: updated.handlerType,
//            status: updated.status,
//            label: labels,
//            handledBy: updated.handledBy,
//            handledAt: updated.handledAt,
//            handledDate: updated.handledDate,
//            isEvaluated: updated.isEvaluated,
//            evaluatedAt: updated.evaluatedAt,
//            resolvedAt: updated.resolvedAt,
//            seenBy: updated.seenBy,
//            internalNotes: updated.internalNotes
//        )
//
//        conversations[index] = updated
//        return updated
//    }
//}
//
//// MARK: - Service Errors
//
//enum ServiceError: LocalizedError {
//    case httpError
//    case notFound
//    case invalidResponse
//    case decodingError
//
//    var errorDescription: String? {
//        switch self {
//        case .httpError:
//            return "HTTP request failed"
//        case .notFound:
//            return "Resource not found"
//        case .invalidResponse:
//            return "Invalid response from server"
//        case .decodingError:
//            return "Failed to decode response"
//        }
//    }
//}
