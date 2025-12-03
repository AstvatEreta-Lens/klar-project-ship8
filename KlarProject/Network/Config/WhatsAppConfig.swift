//
//  WhatsAppConfig.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/11/25.
//

import Foundation
// Config Model
struct WhatsAppConfig: Equatable, Codable {
    var accessToken: String
    var phoneNumberId: String
    var webhookServerURL: String
    var localWebhookPort: String // ubah ke string bair gmpgn

    nonisolated static let `default` = WhatsAppConfig(
        accessToken: "",
        phoneNumberId: "",
        webhookServerURL: "http://localhost:3000",
        localWebhookPort: "http://localhost:8080"
    )
    
    var isValid: Bool {
        !accessToken.isEmpty && !phoneNumberId.isEmpty
    }
}
