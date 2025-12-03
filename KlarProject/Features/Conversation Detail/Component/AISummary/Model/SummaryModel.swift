//
//  SummaryModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import Foundation

// MARK: - AI Summary Model
struct AISummary: Codable, Identifiable {
    let id: UUID
    let sessionId: String
    let summary: String
    let messageCount: Int
    let generatedAt: Date
    
    init(from apiResponse: AISummaryResponse) {
        self.id = UUID()
        self.sessionId = apiResponse.sessionId
        self.summary = apiResponse.summary
        self.messageCount = apiResponse.messageCount
        
        // Parse ISO8601 date
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.generatedAt = formatter.date(from: apiResponse.metadata.generatedAt) ?? Date()
    }
}

// MARK: - API Response Models
struct AISummaryResponse: Codable {
    let success: Bool
    let sessionId: String
    let summary: String
    let messageCount: Int
    let error: String?
    let metadata: SummaryMetadata
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
        case summary
        case messageCount = "message_count"
        case error
        case metadata
    }
}

struct SummaryMetadata: Codable {
    let generatedAt: String
    let source: String
    
    enum CodingKeys: String, CodingKey {
        case generatedAt = "generated_at"
        case source
    }
}

// MARK: - API Wrapper Response
struct SummaryAPIResponse: Codable {
    let success: Bool
    let summary: AISummaryResponse
    let error: String?
}
