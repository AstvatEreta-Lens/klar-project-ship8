//
//  ServiceManager.swift
//  KlarProject
//
//  Created to manage API and Webhook services
//

import Foundation
import Combine
import SwiftUI

@MainActor
class ServiceManager: ObservableObject {
    static let shared = ServiceManager()
    
    private let apiService = APIService.shared
    private let webhookService = WebhookService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isRegistered: Bool = false
    @Published var isWebhookRunning: Bool = false
    @Published var clientId: String
    @Published var errorMessage: String?
    @Published var serverStatus: ServerStatusResponse?
    @Published var isConnected: Bool = false
    @Published var whatsappConfigured: Bool = false
    @Published var latestMessage: WebhookMessageData?
@Published var latestStatusUpdate: StatusUpdateData?
    
    private var statusCheckTimer: Timer?
    
    // Callbacks for message handling
    var onMessageReceived: ((WebhookMessageData) -> Void)?
    var onStatusUpdate: ((StatusUpdateData) -> Void)?
    
    private var configManager = ConfigManager()
    
    private init() {
        self.clientId = UUID().uuidString
        configManager.loadConfig()
        setupWebhookService()
    }
    
    // MARK: - Configuration
    
    func configure(baseURL: String) {
        apiService.configure(baseURL: baseURL)
    }
    
    // MARK: - Client Registration
    
    func register() async {
        guard !isRegistered else {
            print("⚠️ [SERVICE] Client already registered")
            return
        }
        
        print("\n🔌 [SERVICE] Starting client registration...")
        errorMessage = nil
        
        // Get local webhook URL
        let webhookPort = configManager.config.localWebhookPort
        
        // Extract port number if it's a full URL or just a port number
        let port: UInt16
        if let url = URL(string: webhookPort), let urlPort = url.port {
            port = UInt16(urlPort)
        } else if webhookPort.contains(":") {
            // Try to extract from host:port format (e.g., "localhost:8080" or "http://localhost:8080")
            let components = webhookPort.components(separatedBy: ":")
            if components.count > 1 {
                let lastComponent = components.last ?? ""
                // Remove any path after port (e.g., ":8080/webhook" -> "8080")
                let portString = lastComponent.components(separatedBy: "/").first ?? ""
                if let extractedPort = UInt16(portString) {
                    port = extractedPort
                } else {
                    port = 8080 // Default
                }
            } else {
                port = 8080 // Default
            }
        } else if let extractedPort = UInt16(webhookPort) {
            // Just a port number as string
            port = extractedPort
        } else {
            port = 8080 // Default
        }
        
        // Start webhook service
        do {
            print("🔌 [SERVICE] Starting webhook service on port \(port)...")
            try webhookService.start(port: port)
            isWebhookRunning = true
            print("✅ [SERVICE] Webhook service started successfully on port \(port)")
        } catch {
            errorMessage = "Failed to start webhook service: \(error.localizedDescription)"
            print("❌ [SERVICE] Failed to start webhook service: \(error)")
            return
        }
        
        // Build callback URL - use localhost for macOS app
        let callbackUrl = "http://localhost:\(port)/webhook"
        print("🔌 [SERVICE] Registering client with backend...")
        print("🔌 [SERVICE] Client ID: \(clientId)")
        print("🔌 [SERVICE] Callback URL: \(callbackUrl)")
        
        // Register with backend
        do {
            let response = try await apiService.registerClient(
                clientId: clientId,
                callbackUrl: callbackUrl
            )
            
            if response.success {
                isRegistered = true
                print("✅ [SERVICE] Client registered successfully!")
                print("✅ [SERVICE] Client ID: \(clientId)")
                print("✅ [SERVICE] Callback URL: \(callbackUrl)")
                print("✅ [SERVICE] Registration complete\n")
            } else {
                errorMessage = "Registration failed"
                print("❌ [SERVICE] Registration failed - response success: false")
                isWebhookRunning = false
                webhookService.stop()
            }
        } catch {
            errorMessage = error.localizedDescription
            print("❌ [SERVICE] Registration error: \(error)")
            print("❌ [SERVICE] Error details: \(error.localizedDescription)")
            isWebhookRunning = false
            webhookService.stop()
        }
    }
    
    func unregister() async {
        guard isRegistered else {
            print("⚠️ [SERVICE] Client not registered, skipping unregister")
            return
        }
        
        print("\n🔌 [SERVICE] Unregistering client...")
        print("🔌 [SERVICE] Client ID: \(clientId)")
        
        do {
            let _ = try await apiService.unregisterClient(clientId: clientId)
            isRegistered = false
            print("✅ [SERVICE] Client unregistered successfully: \(clientId)\n")
        } catch {
            print("❌ [SERVICE] Unregister error: \(error)")
            print("❌ [SERVICE] Error details: \(error.localizedDescription)\n")
        }
        
        print("🔌 [SERVICE] Stopping webhook service...")
        webhookService.stop()
        isWebhookRunning = false
        print("✅ [SERVICE] Webhook service stopped\n")
    }
    
    // MARK: - Webhook Service Setup
    
  private func setupWebhookService() {
    webhookService.onMessageReceived = { [weak self] messageData in
        print("\n📨 [SERVICE] Webhook received message event")
        print("📨 [SERVICE] Forwarding to registered handlers...")
        
        Task { @MainActor in
            // ✅ PERBAIKAN: Update publisher (akan trigger semua subscribers)
            self?.latestMessage = messageData
            
            // Keep callback for backward compatibility
            self?.onMessageReceived?(messageData)
        }
    }
    
    webhookService.onStatusUpdate = { [weak self] statusData in
        print("\n📊 [SERVICE] Webhook received status update event")
        print("📊 [SERVICE] Forwarding to registered handlers...")
        
        Task { @MainActor in
            // ✅ PERBAIKAN: Update publisher (akan trigger semua subscribers)
            self?.latestStatusUpdate = statusData
            
            // Keep callback for backward compatibility
            self?.onStatusUpdate?(statusData)
        }
    }
}
    
    // MARK: - Server Status
    
    func checkServerStatus() async -> ServerStatusResponse? {
        print("\n🔍 [SERVICE] Checking server status...")
        
        do {
            let status = try await apiService.getServerStatus()
            await MainActor.run {
                self.serverStatus = status
                self.isConnected = status.success
                self.whatsappConfigured = status.whatsappConfigured
            }
            
            print("✅ [SERVICE] Server status check successful")
            print("✅ [SERVICE] Status: \(status.status)")
            print("✅ [SERVICE] Connected: \(status.success)")
            print("✅ [SERVICE] WhatsApp Configured: \(status.whatsappConfigured)")
            print("✅ [SERVICE] Active Clients: \(status.connectedClients)")
            print("✅ [SERVICE] Total Conversations: \(status.totalConversations)")
            print("✅ [SERVICE] Timestamp: \(status.timestamp)\n")
            
            return status
        } catch {
            print("❌ [SERVICE] Error checking server status: \(error)")
            print("❌ [SERVICE] Error details: \(error.localizedDescription)")
            await MainActor.run {
                self.isConnected = false
                self.serverStatus = nil
            }
            print("❌ [SERVICE] Marked as disconnected\n")
            return nil
        }
    }
    
    func startStatusMonitoring() {
        print("\n🔄 [SERVICE] Starting status monitoring...")
        print("🔄 [SERVICE] Will check every 30 seconds")
        
        // Check status immediately
        Task {
            await checkServerStatus()
        }
        
        // Set up periodic status checks (every 30 seconds)
        statusCheckTimer?.invalidate()
        statusCheckTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            Task {
                await self?.checkServerStatus()
            }
        }
        
        print("✅ [SERVICE] Status monitoring started\n")
    }
    
    func stopStatusMonitoring() {
        print("\n🛑 [SERVICE] Stopping status monitoring...")
        statusCheckTimer?.invalidate()
        statusCheckTimer = nil
        print("✅ [SERVICE] Status monitoring stopped\n")
    }
    
    // Computed property for connection status
    var connectionStatus: ConnectionStatus {
        if !isRegistered || !isWebhookRunning {
            return .disconnected
        }
        
        if let status = serverStatus {
            if status.success && status.whatsappConfigured {
                return .connected
            } else if status.success && !status.whatsappConfigured {
                return .serverConnected
            } else {
                return .disconnected
            }
        }
        
        return isRegistered ? .connecting : .disconnected
    }
}

// MARK: - Connection Status
enum ConnectionStatus {
    case connected       // Green - All good (Server + WhatsApp)
    case serverConnected // Yellow - Server OK but WhatsApp not configured
    case connecting      // Yellow - Still connecting
    case disconnected    // Red - Disconnected
    
    var color: Color {
        switch self {
        case .connected:
            return .green
        case .serverConnected, .connecting:
            return .yellow
        case .disconnected:
            return .red
        }
    }
    
    var text: String {
        switch self {
        case .connected:
            return "Terhubung"
        case .serverConnected:
            return "Server Terhubung (WhatsApp Belum Dikonfigurasi)"
        case .connecting:
            return "Menghubungkan..."
        case .disconnected:
            return "Terputus"
        }
    }
}

