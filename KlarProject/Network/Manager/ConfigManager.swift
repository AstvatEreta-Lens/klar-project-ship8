//
//  ConfigManager.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/11/25.
//


import Foundation
import SwiftUI
import Combine


class ConfigManager: ObservableObject {
    @Published var config: WhatsAppConfig = .default
    
    private let userDefaults = UserDefaults.standard
    private let configKey = "whatsapp_config"
    
    func loadConfig() {
        if let data = userDefaults.data(forKey: configKey),
           let decoded = try? JSONDecoder().decode(WhatsAppConfig.self, from: data) {
            config = decoded
        }
    }
    
    func saveConfig() {
        if let encoded = try? JSONEncoder().encode(config) {
            userDefaults.set(encoded, forKey: configKey)
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let newChatRequested = Notification.Name("newChatRequested")
}