////
////  EvaluationService.swift
////  KlarProject
////
////  Created for Backend Integration - Evaluation Feature
////
//
//import Foundation
//
//// MARK: - Protocol
//
//protocol EvaluationServiceProtocol {
//    // Fetch conversations yang bisa di-evaluate (resolved, not yet evaluated)
//    func fetchUnevaluatedConversations() async throws -> [Conversation]
//
//    // Fetch conversations yang sudah di-evaluate
//    func fetchEvaluatedConversations() async throws -> [Conversation]
//
//    // Add conversation to evaluation queue
//    func addToEvaluation(conversationId: UUID) async throws -> Conversation
//
//    // Approve/evaluate conversation
//    func approveConversation(conversationId: UUID) async throws -> Conversation
//
//    // Remove conversation from evaluation
//    func removeFromEvaluation(conversationId: UUID) async throws
//}
//
//// MARK: - API Service (Production)
//
//class APIEvaluationService: EvaluationServiceProtocol {
//    private let baseURL: String
//    private let apiKey: String
//
//    init(baseURL: String = "https://your-api.com/api/v1", apiKey: String) {
//        self.baseURL = baseURL
//        self.apiKey = apiKey
//    }
//
//    func fetchUnevaluatedConversations() async throws -> [Conversation] {
//        let url = URL(string: "\(baseURL)/evaluations/unevaluated")!
//        var request = URLRequest(url: url)
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw EvaluationServiceError.fetchFailed
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return try decoder.decode([Conversation].self, from: data)
//    }
//
//    func fetchEvaluatedConversations() async throws -> [Conversation] {
//        let url = URL(string: "\(baseURL)/evaluations/evaluated")!
//        var request = URLRequest(url: url)
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw EvaluationServiceError.fetchFailed
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return try decoder.decode([Conversation].self, from: data)
//    }
//
//    func addToEvaluation(conversationId: UUID) async throws -> Conversation {
//        let url = URL(string: "\(baseURL)/evaluations")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body = ["conversation_id": conversationId.uuidString]
//        request.httpBody = try JSONSerialization.data(withJSONObject: body)
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              (200...299).contains(httpResponse.statusCode) else {
//            throw EvaluationServiceError.addFailed
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return try decoder.decode(Conversation.self, from: data)
//    }
//
//    func approveConversation(conversationId: UUID) async throws -> Conversation {
//        let url = URL(string: "\(baseURL)/evaluations/\(conversationId.uuidString)/approve")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw EvaluationServiceError.approveFailed
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return try decoder.decode(Conversation.self, from: data)
//    }
//
//    func removeFromEvaluation(conversationId: UUID) async throws {
//        let url = URL(string: "\(baseURL)/evaluations/\(conversationId.uuidString)")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//        let (_, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              (200...299).contains(httpResponse.statusCode) else {
//            throw EvaluationServiceError.removeFailed
//        }
//    }
//}
//
//// MARK: - Mock Service (Development/Testing)
//
//class MockEvaluationService: EvaluationServiceProtocol {
//    // In-memory storage for testing
//    private var unevaluatedConversations: [Conversation] = []
//    private var evaluatedConversations: [Conversation] = []
//
//    // Shared instance
//    static let shared = MockEvaluationService()
//
//    private init() {
//        // Load initial evaluated conversations from dummy data (for testing)
//        let evaluated = Conversation.aiDummyData.filter { $0.isEvaluated == true }
//        evaluatedConversations = evaluated
//    }
//
//    func fetchUnevaluatedConversations() async throws -> [Conversation] {
//        try await Task.sleep(nanoseconds: 300_000_000) // Simulate network delay
//        return unevaluatedConversations
//    }
//
//    func fetchEvaluatedConversations() async throws -> [Conversation] {
//        try await Task.sleep(nanoseconds: 300_000_000)
//        return evaluatedConversations
//    }
//
//    func addToEvaluation(conversationId: UUID) async throws -> Conversation {
//        try await Task.sleep(nanoseconds: 500_000_000)
//
//        // Find conversation from dummy data
//        guard let conversation = (Conversation.aiDummyData + Conversation.humanDummyData)
//            .first(where: { $0.id == conversationId }) else {
//            throw EvaluationServiceError.conversationNotFound
//        }
//
//        // Check if already exists
//        if unevaluatedConversations.contains(where: { $0.id == conversationId }) ||
//           evaluatedConversations.contains(where: { $0.id == conversationId }) {
//            throw EvaluationServiceError.alreadyInEvaluation
//        }
//
//        // Add to unevaluated
//        unevaluatedConversations.insert(conversation, at: 0)
//        print("✅ MockService: Added to evaluation - \(conversation.name)")
//
//        return conversation
//    }
//
//    func approveConversation(conversationId: UUID) async throws -> Conversation {
//        try await Task.sleep(nanoseconds: 500_000_000)
//
//        // Find in unevaluated
//        guard let index = unevaluatedConversations.firstIndex(where: { $0.id == conversationId }) else {
//            throw EvaluationServiceError.conversationNotFound
//        }
//
//        // Update conversation
//        var approved = unevaluatedConversations[index]
//        approved = Conversation(
//            id: approved.id,
//            name: approved.name,
//            message: approved.message,
//            time: approved.time,
//            profileImage: approved.profileImage,
//            unreadCount: approved.unreadCount,
//            hasWhatsApp: approved.hasWhatsApp,
//            phoneNumber: approved.phoneNumber,
//            handlerType: approved.handlerType,
//            status: approved.status,
//            label: approved.label,
//            handledBy: approved.handledBy,
//            handledAt: approved.handledAt,
//            handledDate: approved.handledDate,
//            isEvaluated: true,
//            evaluatedAt: Date(),
//            resolvedAt: approved.resolvedAt,
//            seenBy: approved.seenBy,
//            internalNotes: approved.internalNotes
//        )
//
//        // Remove from unevaluated
//        unevaluatedConversations.remove(at: index)
//
//        // Add to evaluated
//        evaluatedConversations.insert(approved, at: 0)
//
//        print("✅ MockService: Conversation approved - \(approved.name)")
//        return approved
//    }
//
//    func removeFromEvaluation(conversationId: UUID) async throws {
//        try await Task.sleep(nanoseconds: 300_000_000)
//
//        // Remove from both lists
//        unevaluatedConversations.removeAll { $0.id == conversationId }
//        evaluatedConversations.removeAll { $0.id == conversationId }
//
//        print("✅ MockService: Removed from evaluation")
//    }
//}
//
//// MARK: - Service Errors
//
//enum EvaluationServiceError: LocalizedError {
//    case fetchFailed
//    case addFailed
//    case approveFailed
//    case removeFailed
//    case conversationNotFound
//    case alreadyInEvaluation
//
//    var errorDescription: String? {
//        switch self {
//        case .fetchFailed:
//            return "Failed to fetch evaluations"
//        case .addFailed:
//            return "Failed to add conversation to evaluation"
//        case .approveFailed:
//            return "Failed to approve conversation"
//        case .removeFailed:
//            return "Failed to remove conversation"
//        case .conversationNotFound:
//            return "Conversation not found"
//        case .alreadyInEvaluation:
//            return "Conversation already in evaluation"
//        }
//    }
//}
