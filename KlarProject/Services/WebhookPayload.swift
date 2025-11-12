//
//  WebhookPayload.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 06/11/25.
//
//


import Foundation
struct WebhookPayload: Codable {
    let type: String
    let data: WebhookData
    let timestamp: String
}

enum WebhookData: Codable {
    case message(WebhookMessageData)
    case status(StatusUpdateData)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let message = try? container.decode(WebhookMessageData.self) {
            self = .message(message)
        } else if let status = try? container.decode(StatusUpdateData.self) {
            self = .status(status)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode WebhookData"
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .message(let data):
            try container.encode(data)
        case .status(let data):
            try container.encode(data)
        }
    }
}

struct WebhookMessageData: Codable {
    let from: String
    let messageId: String
    let timestamp: String
    let text: WebhookTextData?
    let type: String
    let isFromMe: Bool?

    enum CodingKeys: String, CodingKey {
        case from
        case messageId
        case timestamp
        case text
        case type
        case isFromMe
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        from = try container.decode(String.self, forKey: .from)
        messageId = try container.decode(String.self, forKey: .messageId)
        timestamp = try container.decode(String.self, forKey: .timestamp)
        type = try container.decode(String.self, forKey: .type)
        isFromMe = try? container.decode(Bool.self, forKey: .isFromMe)

        // Handle "text" yang bisa berupa String atau Object
        if let textString = try? container.decode(String.self, forKey: .text) {
            text = WebhookTextData(body: textString)
        } else if let textObject = try? container.decode(WebhookTextData.self, forKey: .text) {
            text = textObject
        } else {
            text = nil
        }
    }
}

struct WebhookTextData: Codable {
    let body: String
}

struct StatusUpdateData: Codable {
    let messageId: String
    let status: String
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case messageId = "id"
        case status
        case timestamp
    }
}


