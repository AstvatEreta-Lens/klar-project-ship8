//
//  WebhookPayload.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/11/25.
//


// MARK: - Webhook Models
struct WebhookPayload: Codable {
    let type: String
    let data: WebhookData
    let timestamp: String
    
    enum WebhookData: Codable {
        case message(WebhookMessageData)
        case status(StatusUpdateData)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Check if there's a type field in the data object itself
            if let dataType = try? container.decode(String.self, forKey: .type) {
                if dataType == "status" {
                    let statusData = try StatusUpdateData(from: decoder)
                    self = .status(statusData)
                    return
                }
            }
            
            // Otherwise, try to decode as message
            // Check for status-specific fields
            if container.contains(.status) && container.contains(.messageId) && container.contains(.recipientId) {
                let statusData = try StatusUpdateData(from: decoder)
                self = .status(statusData)
            } else {
                // Try as message data
                let messageData = try WebhookMessageData(from: decoder)
                self = .message(messageData)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            switch self {
            case .message(let data):
                try data.encode(to: encoder)
            case .status(let data):
                try data.encode(to: encoder)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case type
            case status
            case messageId
            case recipientId
        }
    }
}

struct WebhookMessageData: Codable {
    let messageId: String?
    let from: String?
    let timestamp: String?
    let type: String?
    let text: String?
    let isFromMe: Bool?
    let to: String?
    let status: String?
    let isAIReply: Bool?
    let aiStatus: String?  // ✅ TAMBAHKAN INI
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        messageId = try? container.decode(String.self, forKey: .messageId)
        from = try? container.decode(String.self, forKey: .from)
        timestamp = try? container.decode(String.self, forKey: .timestamp)
        type = try? container.decode(String.self, forKey: .type)
        text = try? container.decode(String.self, forKey: .text)
        isFromMe = try? container.decode(Bool.self, forKey: .isFromMe)
        to = try? container.decode(String.self, forKey: .to)
        status = try? container.decode(String.self, forKey: .status)
        isAIReply = try? container.decode(Bool.self, forKey: .isAIReply)
        aiStatus = try? container.decode(String.self, forKey: .aiStatus)  // ✅ TAMBAHKAN INI
    }
    
    enum CodingKeys: String, CodingKey {
        case messageId
        case from
        case timestamp
        case type
        case text
        case isFromMe
        case to
        case status
        case isAIReply
        case aiStatus  // ✅ TAMBAHKAN INI
    }
}
struct StatusUpdateData: Codable {
    let type: String
    let messageId: String
    let status: String
    let timestamp: String
    let recipientId: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = (try? container.decode(String.self, forKey: .type)) ?? "status"
        messageId = try container.decode(String.self, forKey: .messageId)
        status = try container.decode(String.self, forKey: .status)
        timestamp = try container.decode(String.self, forKey: .timestamp)
        recipientId = try container.decode(String.self, forKey: .recipientId)
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case messageId
        case status
        case timestamp
        case recipientId
    }
}	
