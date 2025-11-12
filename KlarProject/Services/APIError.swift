//
//  APIError.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 06/11/25.
//

import Foundation

// MARK: - API Errors
enum APIError: LocalizedError {
    case invalidResponse
    case registrationFailed
    case sendMessageFailed(String)
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .registrationFailed:
            return "Failed to register with server"
        case .sendMessageFailed(let message):
            return "Failed to send message: \(message)"
        case .networkError:
            return "Network error occurred"
        }
    }
}
