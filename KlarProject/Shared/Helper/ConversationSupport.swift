//
//  ConversationSupport.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 05/11/25.
//

import Foundation

// MARK: - User Extension for Codable

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, profileImage, email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        profileImage = try container.decode(String.self, forKey: .profileImage)
        email = try container.decode(String.self, forKey: .email)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(profileImage, forKey: .profileImage)
        try container.encode(email, forKey: .email)
    }
}

// MARK: - SeenByRecord Extension for Codable

extension SeenByRecord: Codable {
    enum CodingKeys: String, CodingKey {
        case id, user, seenAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        user = try container.decode(User.self, forKey: .user)
        seenAt = try container.decode(String.self, forKey: .seenAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(user, forKey: .user)
        try container.encode(seenAt, forKey: .seenAt)
    }
}
