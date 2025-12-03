//
//  APIService.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/11/25.
//




// APIService.swift
import Foundation

// MARK: - API Service
class APIService {
    static let shared = APIService()
    private let session = URLSession.shared
    private var baseURL: String = "http://localhost:3000"
    
    private init() {}
    
    func configure(baseURL: String) {
        self.baseURL = baseURL
    }
    
    // MARK: - Client Registration
    func registerClient(clientId: String, callbackUrl: String) async throws -> RegistrationResponse {
        let url = URL(string: "\(baseURL)/api/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let payload: [String: String] = [
            "clientId": clientId,
            "callbackUrl": callbackUrl
        ]
        
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        if (200...299).contains(httpResponse.statusCode) {
            return try decoder.decode(RegistrationResponse.self, from: data)
        } else {
            _ = try? decoder.decode(ErrorResponse.self, from: data)
            throw APIError.registrationFailed
        }
    }
    
    // MARK: - Unregister Client
    func unregisterClient(clientId: String) async throws -> UnregisterResponse {
        let url = URL(string: "\(baseURL)/api/unregister")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let payload: [String: String] = ["clientId": clientId]
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        if (200...299).contains(httpResponse.statusCode) {
            return try decoder.decode(UnregisterResponse.self, from: data)
        } else {
            throw APIError.registrationFailed
        }
    }
    
    // MARK: - Send Message
    func sendMessage(to phoneNumber: String, message: String, type: String = "text", clientId: String) async throws -> SendMessageResponse {
        let url = URL(string: "\(baseURL)/api/send-message")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        let payload: [String: Any] = [
            "to": phoneNumber,
            "message": message,
            "type": type,
            "clientId": clientId
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        let decoder = JSONDecoder()

        if (200...299).contains(httpResponse.statusCode) {
            return try decoder.decode(SendMessageResponse.self, from: data)
        } else {
            let errorResponse = try? decoder.decode(ErrorResponse.self, from: data)
            throw APIError.sendMessageFailed(errorResponse?.error ?? "Unknown error")
        }
    }
    
    // MARK: - Get Conversations
//    func getConversations() async throws -> [ConversationData] {
//        
//        let url = URL(string: "\(baseURL)/api/conversations")!
//        var request = URLRequest(url: url)
//        request.timeoutInterval = 10
//        
//        let (data, response) = try await session.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw APIError.invalidResponse
//        }
//        
//        let decoder = JSONDecoder()
//        
//        if (200...299).contains(httpResponse.statusCode) {
//            let result = try decoder.decode(ConversationsResponse.self, from: data)
//            return result.conversations ?? []
//        } else {
//            throw APIError.invalidResponse
//        }
//    }
    
    
    func getConversations(clientId: String) async throws -> [ConversationData] {
        // ✅ Tambahkan clientId sebagai query parameter
        guard let encodedClientId = clientId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw APIError.invalidResponse
        }
        
        let url = URL(string: "\(baseURL)/api/conversations?clientId=\(encodedClientId)")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        if (200...299).contains(httpResponse.statusCode) {
            let result = try decoder.decode(ConversationsResponse.self, from: data)
            return result.conversations ?? []
        } else {
            throw APIError.invalidResponse
        }
    }

    // ✅ TAMBAHKAN FUNCTION BARU: Mark Conversation as Read
    func markConversationAsRead(clientId: String, phoneNumber: String) async throws {
        let url = URL(string: "\(baseURL)/api/mark-read")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let payload: [String: String] = [
            "clientId": clientId,
            "phoneNumber": phoneNumber
        ]
        
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        print("📖 [API] Marked conversation as read: \(phoneNumber)")
    }

//
    // MARK: - Get Messages for Contact
    func getMessages(for phoneNumber: String) async throws -> [APIMessageData] {
        guard let encodedPhoneNumber = phoneNumber.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.invalidResponse
        }
        
        let url = URL(string: "\(baseURL)/api/messages/\(encodedPhoneNumber)")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        if (200...299).contains(httpResponse.statusCode) {
            let result = try decoder.decode(MessagesResponse.self, from: data)
            return result.messages ?? []
        } else {
            throw APIError.invalidResponse
        }
    }
    
    // MARK: - Get Server Status
    func getServerStatus() async throws -> ServerStatusResponse {
        let url = URL(string: "\(baseURL)/api/status")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ServerStatusResponse.self, from: data)
    }
    
    func generateSummary(phoneNumber: String) async throws -> AISummaryResponse {
        guard let encodedPhoneNumber = phoneNumber.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.invalidResponse
        }
        
        let url = URL(string: "\(baseURL)/api/summary/\(encodedPhoneNumber)")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        
        print("📊 [API] Requesting summary for: \(phoneNumber)")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        if (200...299).contains(httpResponse.statusCode) {
            let result = try decoder.decode(SummaryAPIResponse.self, from: data)
            
            guard result.success else {
                throw APIError.requestFailed
            }
            
            print("✅ [API] Summary received successfully")
            return result.summary
            
        } else {
            let errorResponse = try? decoder.decode(SummaryAPIResponse.self, from: data)
            throw APIError.sendMessageFailed(errorResponse?.error ?? "Unknown error")
        }
    }

    func deleteSummary(sessionId: String) async throws {
        guard let encodedSessionId = sessionId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.invalidResponse
        }
        
        let url = URL(string: "\(baseURL)/api/summary/\(encodedSessionId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.timeoutInterval = 10
        
        print("🗑️  [API] Deleting summary for: \(sessionId)")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        print("✅ [API] Summary deleted successfully")
    }


}

// MARK: - Helper Response Models
struct RegistrationResponse: Codable {
    let success: Bool
    let clientId: String?
    let message: String?
}

struct UnregisterResponse: Codable {
    let success: Bool
    let message: String?
}

struct ErrorResponse: Codable {
    let success: Bool
    let error: String?
}

struct ServerStatusResponse: Codable {
    let success: Bool
    let status: String
    let connectedClients: Int
    let totalConversations: Int
    let whatsappConfigured: Bool
    let timestamp: String
}





