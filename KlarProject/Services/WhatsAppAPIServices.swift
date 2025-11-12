//
//  WhatsAppAPIServices.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 06/11/25.
//

import Foundation
import Network

class WhatsAppAPIService{
    static let shared = WhatsAppAPIService()
    private let session = URLSession.shared
    private var baseURL: String = "http://localhost:3000"
    
    private init(){}
    
    func configure(baseURL:String){
        
        self.baseURL = baseURL
        
    }
    
    // MARK: Client Registration
    func registerClient(clientId:String, callbackUrl: String) async throws -> Bool{
        let url = URL(string: "\(baseURL)/api/register")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: String] = [
            "clientId": clientId,
            "callbackUrl": callbackUrl
        ]
        
        request.httpBody = try? JSONEncoder().encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
            throw APIError.registrationFailed
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(RegistrationResponse.self, from: data)
        return result.success
        
    }
    // MARK: Send Message
    func  sendMessage(to phoneNumber: String, text: String, clientId: String) async throws -> SendMessageResponse {
        let url = URL(string: "\(baseURL)/api/send-message")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: String] = [
            "to": phoneNumber,
            "message": text,
            "type": "text",
            "clientId": clientId
        ]
        
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        if httpResponse.statusCode == 200 {
            return try decoder.decode(SendMessageResponse.self, from: data)
        } else {
            let errorResponse = try? decoder.decode(SendMessageResponse.self, from: data)
            throw APIError.sendMessageFailed(errorResponse?.error ?? "Unknown error")
        }
    }
    
    //MARK: Get Conversations
    func getConversations() async throws -> [ConversationData] {
        let url = URL(string: "\(baseURL)/api/conversations")!
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(ConversationsResponse.self, from: data)
        return result.conversations ?? []
    }
    
    // MARK: - Get Messages for Contact
    func getMessages(for phoneNumber: String) async throws -> [APIMessageData] {
        let url = URL(string: "\(baseURL)/api/messages/\(phoneNumber)")!
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(MessagesResponse.self, from: data)
        return result.messages ?? []
    }
    
    // MARK: - Unregister Client
    func unregisterClient(clientId: String) async throws {
        let url = URL(string: "\(baseURL)/api/unregister")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: String] = ["clientId": clientId]
        request.httpBody = try JSONEncoder().encode(payload)
        
        let _ = try await session.data(for: request)
    }
    
}
