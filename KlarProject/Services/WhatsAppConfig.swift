//
//  WhatsAppConfig.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 06/11/25.
//

import Foundation
// MARK: - Configuration Model
struct WhatsAppConfig: Codable {
    var accessToken: String
    var phoneNumberId: String
    var webhookServerURL: String
    var localWebhookPort: UInt16
    
    static var `default`: WhatsAppConfig {
        WhatsAppConfig(
            accessToken: "",
            phoneNumberId: "",
            webhookServerURL: "http://localhost:3000",
            localWebhookPort: 8080
        )
    }
    
    var isValid: Bool {
        !accessToken.isEmpty && !phoneNumberId.isEmpty
    }
}
