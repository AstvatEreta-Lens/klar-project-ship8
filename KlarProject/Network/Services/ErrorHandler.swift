//
//  ErrorHandler.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/11/25.
//
import Foundation
// MARK: - API Errors

enum APIError: LocalizedError {
    case invalidResponse
    case registrationFailed
    case sendMessageFailed(String)
    case networkError
    case unauthorized
    case invalidMessage
    case messageNotFound
    case deleteFailed
    case llmApiFailed
    case invalidLLMResponse
    case saveFailed
    case unknown(Error)
    case httpError(statusCode: Int)
    case requestFailed
    
    var errorDescription: String? {
        switch self {
        case .requestFailed:
            return "Failed to perform request: "
        case .invalidResponse:
            return "Invalid server response"
        case .registrationFailed:
            return "Failed to register with server"
        case .sendMessageFailed(let message):
            return "Failed to send message: \(message)"
        case .networkError:
            return "Network error occurred"
        case .unauthorized:
            return "You are not authorized to perform this action"
        case .messageNotFound:
            return "Message not found"
        case .invalidMessage:
            return "Invalid message format"
        case .unknown(let error):
            return "An error occurred: \(error.localizedDescription)"
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

