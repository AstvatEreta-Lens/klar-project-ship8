//
//  SettingsView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//
//import SwiftUI
//
//struct SettingsView: View {
//    @Binding var config: WhatsAppConfig
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("WhatsApp Configuration")
//                .font(.headline)
//                .padding(.top)
//            
//            Form {
//                Section("Credentials") {
//                    TextField("Access Token", text: $config.accessToken)
//                        .textFieldStyle(.roundedBorder)
//                    
//                    TextField("Phone Number ID", text: $config.phoneNumberId)
//                        .textFieldStyle(.roundedBorder)
//                    
//                    TextField("Webhook Server URL", text: $config.webhookServerURL)
//                        .textFieldStyle(.roundedBorder)
//                }
//                
//                Section("Status") {
//                    HStack {
//                        Text("Configuration:")
//                        Spacer()
//                        if config.accessToken.isEmpty || config.phoneNumberId.isEmpty {
//                            Text("Incomplete")
//                                .foregroundColor(.orange)
//                        } else {
//                            Text("Complete")
//                                .foregroundColor(.green)
//                        }
//                    }
//                }
//            }
//            .formStyle(.grouped)
//            
//            HStack {
//                Button("Reset to Default") {
//                    config = .default
//                }
//                .buttonStyle(.bordered)
//                
//                Spacer()
//                
//                Button("Close") {
//                    dismiss()
//                }
//                .buttonStyle(.borderedProminent)
//                .keyboardShortcut(.defaultAction)
//            }
//            .padding(.horizontal)
//            .padding(.bottom)
//        }
//        .frame(width: 500, height: 350)
//    }
//}
//
//#Preview {
//    SettingsView(config: WhatsAppConfig, dismiss: { })
//}
