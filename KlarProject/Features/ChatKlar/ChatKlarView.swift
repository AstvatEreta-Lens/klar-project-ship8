//
//  ChatKlarView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//  Updated with TakeOver functionality
//
//
//import SwiftUI
//
//struct ChatKlarView: View {
//    @StateObject private var viewModel = ConversationListViewModel()
//    
//    var body: some View {
//        GeometryReader { geometry in
//            HStack(spacing: 0) {
//                // MARK: -Conversation List
//                ConversationListView(viewModel: viewModel)
//                    .frame(width: 334)
//                    .frame(maxHeight: .infinity, alignment: .top)
//                
//                Divider() 
//                    .frame(height: geometry.size.height)
//                
//                // MARK: -Main Chat
//                if viewModel.selectedConversation != nil {
//                    MainChatView()
//                        .environmentObject(viewModel)
//                        .padding(.top, 12)
//                        .padding(.bottom, 12)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                } else {
//                    // Empty state
//                    VStack(spacing: 363) {
//                        Image("Logo")
//                            .font(.system(size: 64))
//                            .foregroundColor(.gray.opacity(0.3))
//                        
//                        Text("Select a conversation to see message")
//                            .font(.system(size: 18))
//                            .foregroundColor(.gray)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color.backgroundPrimary)
//                }
//                
//                Divider()
//                    .frame(height: geometry.size.height)
//                
//                // MARK: -Chat Detail
//                if let conversation = viewModel.selectedConversation {
//                    ChatDetailView(conversation: conversation)
//                        .frame(width: 334)
//                        .frame(maxHeight: .infinity, alignment: .top)
//                        .id(conversation.id)
//                }
//            }
//            .frame(width: geometry.size.width, height: geometry.size.height)
//            .background(Color.backgroundPrimary)
//        }
//    }
//}
//
//#Preview {
//    ChatKlarView()
//        .frame(width: 1400, height: 982)
//}
// ChatKlarView.swift
//import SwiftUI
//
//struct ChatKlarView: View {
//    @StateObject private var viewModel = ConversationListViewModel()
//    @StateObject private var configManager = ConfigManager()
//    @State private var showingConfiguration = false
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                // Main Content
//                HStack(spacing: 0) {
//                    // MARK: - Conversation List
//                    ConversationListView(viewModel: viewModel)
//                        .frame(width: 334)
//                        .frame(maxHeight: .infinity, alignment: .top)
//                    
//                    Divider()
//                        .frame(height: geometry.size.height)
//                    
//                    // MARK: - Main Chat
//                    if viewModel.selectedConversation != nil {
//                        MainChatView()
//                            .environmentObject(viewModel)
//                            .padding(.top, 12)
//                            .padding(.bottom, 12)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    } else {
//                        // Empty state
//                        VStack(spacing: 24) {
//                            Image("Logo")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 120, height: 120)
//                                .foregroundColor(.gray.opacity(0.3))
//                            
//                            VStack(spacing: 8) {
//                                Text("Select a conversation to see message")
//                                    .font(.system(size: 18))
//                                    .foregroundColor(.gray)
//                                
//                                // Connection status in empty state
//                                HStack(spacing: 8) {
//                                    Circle()
//                                        .fill(viewModel.isConnected ? Color.green : Color.gray)
//                                        .frame(width: 8, height: 8)
//                                    
//                                    Text(viewModel.isConnected ? "WhatsApp Connected" : "Not Connected")
//                                        .font(.caption)
//                                        .foregroundColor(.secondary)
//                                }
//                                
//                                if !viewModel.isConnected {
//                                    Button(action: {
//                                        showingConfiguration = true
//                                    }) {
//                                        HStack {
//                                            Image(systemName: "gear")
//                                            Text("Configure WhatsApp")
//                                        }
//                                        .font(.caption)
//                                        .padding(.horizontal, 12)
//                                        .padding(.vertical, 6)
//                                        .background(Color.blue.opacity(0.1))
//                                        .foregroundColor(.blue)
//                                        .cornerRadius(6)
//                                    }
//                                    .buttonStyle(PlainButtonStyle())
//                                }
//                            }
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.backgroundPrimary)
//                    }
//                    
//                    Divider()
//                        .frame(height: geometry.size.height)
//                    
//                    // MARK: - Chat Detail
//                    if let conversation = viewModel.selectedConversation {
//                        ChatDetailView(
//                            conversation: conversation,
//                            onConversationUpdated: { updatedConv in
//                                // Update conversation in viewModel
//                                if updatedConv.handlerType == .human {
//                                    if let index = viewModel.humanConversations.firstIndex(where: { $0.id == updatedConv.id }) {
//                                        viewModel.humanConversations[index] = updatedConv
//                                    }
//                                } else {
//                                    if let index = viewModel.aiConversations.firstIndex(where: { $0.id == updatedConv.id }) {
//                                        viewModel.aiConversations[index] = updatedConv
//                                    }
//                                }
//                                viewModel.selectedConversation = updatedConv
//                            }
//                        )
//                        .frame(width: 334)
//                        .frame(maxHeight: .infinity, alignment: .top)
//                        .id(conversation.id)
//                    }
//                }
//                .frame(width: geometry.size.width, height: geometry.size.height)
//                .background(Color.backgroundPrimary)
//                
//                // Configuration Button (Floating)
//                VStack {
//                    HStack {
//                        Spacer()
//                        
//                        Button(action: {
//                            showingConfiguration.toggle()
//                        }) {
//                            HStack(spacing: 6) {
//                                Circle()
//                                    .fill(viewModel.isConnected ? Color.green : Color.red)
//                                    .frame(width: 8, height: 8)
//                                
//                                Image(systemName: "gear")
//                                    .font(.system(size: 16))
//                            }
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 8)
//                            .background(Color(NSColor.controlBackgroundColor))
//                            .cornerRadius(8)
//                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                        .padding(.trailing, 350)
//                        .padding(.top, 16)
//                    }
//                    
//                    Spacer()
//                }
//            }
//        }
//        .sheet(isPresented: $showingConfiguration) {
//            WhatsAppConfigurationView(
//                config: $configManager.config,
//                isConnected: viewModel.isConnected,
//                onConnect: {
//                    Task {
//                        await viewModel.connect(with: configManager.config)
//                        configManager.saveConfig()
//                    }
//                },
//                onDisconnect: {
//                    Task {
//                        await viewModel.disconnect()
//                    }
//                }
//            )
//        }
//        .onAppear {
//            // Load saved configuration
//            configManager.loadConfig()
//            
//            // Auto-connect if config is valid
//            if configManager.config.isValid && !viewModel.isConnected {
//                Task {
//                    await viewModel.connect(with: configManager.config)
//                }
//            }
//        }
//    }
//}
//
//// MARK: - WhatsApp Configuration View
//struct WhatsAppConfigurationView: View {
//    @Binding var config: WhatsAppConfig
//    let isConnected: Bool
//    let onConnect: () -> Void
//    let onDisconnect: () -> Void
//    
//    @Environment(\.dismiss) var dismiss
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Header
//            HStack {
//                Text("WhatsApp Configuration")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                
//                Spacer()
//                
//                Button(action: { dismiss() }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .font(.system(size: 20))
//                        .foregroundColor(.secondary)
//                }
//                .buttonStyle(PlainButtonStyle())
//            }
//            .padding()
//            .background(Color(NSColor.controlBackgroundColor))
//            
//            Divider()
//            
//            // Configuration Form
//            ScrollView {
//                VStack(spacing: 24) {
//                    // WhatsApp API Section
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text("WhatsApp Cloud API")
//                            .font(.headline)
//                            .foregroundColor(.primary)
//                        
//                        // Access Token
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Text("Access Token")
//                                    .font(.subheadline)
//                                    .fontWeight(.medium)
//                                
//                                Text("*")
//                                    .foregroundColor(.red)
//                            }
//                            
//                            SecureField("Enter your access token", text: $config.accessToken)
//                                .textFieldStyle(.roundedBorder)
//                                .disabled(isConnected)
//                            
//                            Text("Get this from Facebook Developer Portal")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        
//                        // Phone Number ID
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Text("Phone Number ID")
//                                    .font(.subheadline)
//                                    .fontWeight(.medium)
//                                
//                                Text("*")
//                                    .foregroundColor(.red)
//                            }
//                            
//                            TextField("Enter phone number ID", text: $config.phoneNumberId)
//                                .textFieldStyle(.roundedBorder)
//                                .disabled(isConnected)
//                            
//                            Text("Your WhatsApp Business phone number ID")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    .padding()
//                    .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
//                    .cornerRadius(12)
//                    
//                    // Server Configuration Section
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text("Server Configuration")
//                            .font(.headline)
//                            .foregroundColor(.primary)
//                        
//                        // Webhook Server URL
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Text("Webhook Server URL")
//                                    .font(.subheadline)
//                                    .fontWeight(.medium)
//                                
//                                Text("*")
//                                    .foregroundColor(.red)
//                            }
//                            
//                            TextField("http://localhost:3000", text: $config.webhookServerURL)
//                                .textFieldStyle(.roundedBorder)
//                                .disabled(isConnected)
//                            
//                            Text("Your backend server URL")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        
//                        // Local Webhook Port
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Local Webhook Port")
//                                .font(.subheadline)
//                                .fontWeight(.medium)
//                            
//                            TextField("8080", value: $config.localWebhookPort, format: .number)
//                                .textFieldStyle(.roundedBorder)
//                                .disabled(isConnected)
//                            
//                            Text("Port for receiving webhooks (default: 8080)")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    .padding()
//                    .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
//                    .cornerRadius(12)
//                    
//                    // Connection Status
//                    if isConnected {
//                        HStack {
//                            Image(systemName: "checkmark.circle.fill")
//                                .foregroundColor(.green)
//                            
//                            Text("Connected to WhatsApp API")
//                                .font(.subheadline)
//                                .foregroundColor(.green)
//                            
//                            Spacer()
//                        }
//                        .padding()
//                        .background(Color.green.opacity(0.1))
//                        .cornerRadius(12)
//                    }
//                }
//                .padding()
//            }
//            
//            Divider()
//            
//            // Action Buttons
//            HStack(spacing: 12) {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Text("Cancel")
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .background(Color(NSColor.controlBackgroundColor))
//                        .cornerRadius(8)
//                }
//                .buttonStyle(PlainButtonStyle())
//                
//                if isConnected {
//                    Button(action: {
//                        onDisconnect()
//                        dismiss()
//                    }) {
//                        Text("Disconnect")
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 12)
//                            .background(Color.red)
//                            .cornerRadius(8)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                } else {
//                    Button(action: {
//                        if config.isValid {
//                            onConnect()
//                            dismiss()
//                        } else {
//                            alertMessage = "Please fill in all required fields marked with *"
//                            showingAlert = true
//                        }
//                    }) {
//                        Text("Connect")
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 12)
//                            .background(config.isValid ? Color.blue : Color.gray)
//                            .cornerRadius(8)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .disabled(!config.isValid)
//                }
//            }
//            .padding()
//            .background(Color(NSColor.controlBackgroundColor))
//        }
//        .frame(width: 600, height: 650)
//        .alert("Configuration Error", isPresented: $showingAlert) {
//            Button("OK", role: .cancel) { }
//        } message: {
//            Text(alertMessage)
//        }
//    }
//}
//
////// MARK: - Background Color Extension
////extension Color {
////    static let backgroundPrimary = Color(NSColor.controlBackgroundColor)
////}
//
//#Preview {
//    ChatKlarView()
//        .frame(width: 1400, height: 982)
//}


// ChatKlarView.swift
import SwiftUI

struct ChatKlarView: View {
    @StateObject private var viewModel = ConversationListViewModel()
    @StateObject private var configManager = ConfigManager()
    @StateObject private var testNumbersManager = TestNumbersManager()
    @State private var showingConfiguration = false
    @State private var showingTestNumbers = false
    @State private var showingNewChat = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main Content
                HStack(spacing: 0) {
                    // MARK: - Conversation List
                    ConversationListView(viewModel: viewModel)
                        .frame(width: 334)
                        .frame(maxHeight: .infinity, alignment: .top)
                    
                    Divider()
                        .frame(height: geometry.size.height)
                    
                    // MARK: - Main Chat
                    if viewModel.selectedConversation != nil {
                        MainChatView()
                            .environmentObject(viewModel)
                            .padding(.top, 12)
                            .padding(.bottom, 12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Empty state
                        VStack(spacing: 24) {
                            Image("Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray.opacity(0.3))
                            
                            VStack(spacing: 8) {
                                Text("Select a conversation to see message")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                
                                // Connection status in empty state
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(viewModel.isConnected ? Color.green : Color.gray)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(viewModel.isConnected ? "WhatsApp Connected" : "Not Connected")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                if !viewModel.isConnected {
                                    Button(action: {
                                        showingConfiguration = true
                                    }) {
                                        HStack {
                                            Image(systemName: "gear")
                                            Text("Configure WhatsApp")
                                        }
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(6)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.backgroundPrimary)
                    }
                    
                    Divider()
                        .frame(height: geometry.size.height)
                    
                    // MARK: - Chat Detail
                    if let conversation = viewModel.selectedConversation {
                        ChatDetailView(
                            conversation: conversation,
                            onConversationUpdated: { updatedConv in
                                // Update conversation in viewModel
                                if updatedConv.handlerType == .human {
                                    if let index = viewModel.humanConversations.firstIndex(where: { $0.id == updatedConv.id }) {
                                        viewModel.humanConversations[index] = updatedConv
                                    }
                                } else {
                                    if let index = viewModel.aiConversations.firstIndex(where: { $0.id == updatedConv.id }) {
                                        viewModel.aiConversations[index] = updatedConv
                                    }
                                }
                                viewModel.selectedConversation = updatedConv
                            }
                        )
                        .frame(width: 334)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .id(conversation.id)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.backgroundPrimary)
                
                // Configuration Button (Floating)
                VStack {
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 8) {
                            // New Chat with Test Number
                            Button(action: {
                                showingNewChat = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "plus.message.fill")
                                        .font(.system(size: 14))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .help("New chat with test number")
                            
                            // Test Numbers Manager
                            Button(action: {
                                showingTestNumbers = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "phone.badge.plus")
                                        .font(.system(size: 14))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .help("Manage test numbers")
                            
                            // Configuration
                            Button(action: {
                                showingConfiguration.toggle()
                            }) {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(viewModel.isConnected ? Color.green : Color.red)
                                        .frame(width: 8, height: 8)
                                    
                                    Image(systemName: "gear")
                                        .font(.system(size: 16))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(NSColor.controlBackgroundColor))
                                .cornerRadius(8)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .help("Settings")
                        }
                        .padding(.trailing, 350)
                        .padding(.top, 16)
                    }
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingConfiguration) {
            WhatsAppConfigurationView(
                config: $configManager.config,
                isConnected: viewModel.isConnected,
                onConnect: {
                    Task {
                        await viewModel.connect(with: configManager.config)
                        configManager.saveConfig()
                    }
                },
                onDisconnect: {
                    Task {
                        await viewModel.disconnect()
                    }
                }
            )
        }
        .sheet(isPresented: $showingTestNumbers) {
            TestNumbersView()
                .environmentObject(testNumbersManager)
        }
        .sheet(isPresented: $showingNewChat) {
            NewChatView(
                testNumbersManager: testNumbersManager,
                onCreateChat: { testNumber in
                    let conversation = testNumbersManager.createConversation(from: testNumber)
                    
                    // Add to human conversations
                    viewModel.humanConversations.insert(conversation, at: 0)
                    viewModel.selectConversation(conversation)
                    
                    showingNewChat = false
                }
            )
        }
        .onAppear {
            // Load saved configuration
            configManager.loadConfig()
            
            // Auto-connect if config is valid
            if configManager.config.isValid && !viewModel.isConnected {
                Task {
                    await viewModel.connect(with: configManager.config)
                }
            }
        }
    }
}

// MARK: - WhatsApp Configuration View
struct WhatsAppConfigurationView: View {
    @Binding var config: WhatsAppConfig
    let isConnected: Bool
    let onConnect: () -> Void
    let onDisconnect: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("WhatsApp Configuration")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Configuration Form
            ScrollView {
                VStack(spacing: 24) {
                    // WhatsApp API Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("WhatsApp Cloud API")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        // Access Token
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Access Token")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text("*")
                                    .foregroundColor(.red)
                            }
                            
                            SecureField("Enter your access token", text: $config.accessToken)
                                .textFieldStyle(.roundedBorder)
                                .disabled(isConnected)
                            
                            Text("Get this from Facebook Developer Portal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Phone Number ID
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Phone Number ID")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text("*")
                                    .foregroundColor(.red)
                            }
                            
                            TextField("Enter phone number ID", text: $config.phoneNumberId)
                                .textFieldStyle(.roundedBorder)
                                .disabled(isConnected)
                            
                            Text("Your WhatsApp Business phone number ID")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                    .cornerRadius(12)
                    
                    // Server Configuration Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Server Configuration")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        // Webhook Server URL
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Webhook Server URL")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text("*")
                                    .foregroundColor(.red)
                            }
                            
                            TextField("http://localhost:3000", text: $config.webhookServerURL)
                                .textFieldStyle(.roundedBorder)
                                .disabled(isConnected)
                            
                            Text("Your backend server URL")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Local Webhook Port
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Local Webhook Port")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("8080", value: $config.localWebhookPort, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .disabled(isConnected)
                            
                            Text("Port for receiving webhooks (default: 8080)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                    .cornerRadius(12)
                    
                    // Connection Status
                    if isConnected {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            
                            Text("Connected to WhatsApp API")
                                .font(.subheadline)
                                .foregroundColor(.green)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            
            Divider()
            
            // Action Buttons
            HStack(spacing: 12) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                
                if isConnected {
                    Button(action: {
                        onDisconnect()
                        dismiss()
                    }) {
                        Text("Disconnect")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        if config.isValid {
                            onConnect()
                            dismiss()
                        } else {
                            alertMessage = "Please fill in all required fields marked with *"
                            showingAlert = true
                        }
                    }) {
                        Text("Connect")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(config.isValid ? Color.blue : Color.gray)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(!config.isValid)
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
        }
        .frame(width: 600, height: 650)
        .alert("Configuration Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}


#Preview {
    ChatKlarView()
        .frame(width: 1400, height: 982)
}
