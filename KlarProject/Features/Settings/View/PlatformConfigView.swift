//
//  PlatformConfigView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 12/11/25.
//


import SwiftUI

struct PlatformConfigView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedProfileIndex: Int = 0
    let tutorialAction: () -> Void
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Platform Configuration")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.sectionHeader)
           
                    
                VStack(alignment : .leading) {
                    
                    HStack{
                        Text("Whatsapp Business")
                            .foregroundColor(Color.sectionHeader)
                        Text("Website")
                        Text("Email")
                    }
                    .foregroundColor(Color.textRegular)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Divider()
                        .foregroundColor(Color.sectionHeader)
                    
                        fieldRow(title: NSLocalizedString("Access Token", comment: ""), text: binding(for: \.accessToken))
                    fieldRow(title: NSLocalizedString("Phone Number ID", comment : ""), text: binding(for: \.phoneNumberId))
                    fieldRow(title: NSLocalizedString("Verify Token", comment : ""), text: binding(for: \.localWebhookPort))
                    fieldRow(title: NSLocalizedString("Webhook URL", comment : ""), text: binding(for: \.webhookServerURL))
                    
                    HStack{
                        Text("How can I connect my platform to this app?")
                            .font(.caption2)
                            .foregroundColor(Color.textRegular)
                            .padding(.leading)
                        Button(action : tutorialAction){
                            Text("tutorial")
                                .font(.caption2)
                                .foregroundColor(Color.icon)
                                .underline(true)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom)
                    }
//                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.sectionHeader, lineWidth: 1)
                    )
                    .padding(.bottom)
            }
    }
    
    private var config: WhatsAppConfig? {
        guard viewModel.platformConfigs.indices.contains(selectedProfileIndex) else { return nil }
        return viewModel.platformConfigs[selectedProfileIndex]
    }
    
    private func fieldRow(title: String, text: Binding<String>) -> some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.body)
                .foregroundColor(Color.textRegular)
//                .frame(minWidth: 120)
            Spacer()
            EditableTextBox(text: text)
                .frame(minWidth: 200, maxWidth: 300)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func binding(for keyPath: WritableKeyPath<WhatsAppConfig, String>) -> Binding<String> {
        Binding(
            get: {
                guard let platformConfigs = config else { return "" }
                return platformConfigs[keyPath: keyPath]
            },
            set: { newValue in
                guard viewModel.platformConfigs.indices.contains(selectedProfileIndex) else { return }
                viewModel.platformConfigs[selectedProfileIndex][keyPath: keyPath] = newValue
            }
        )
    }
}

#Preview {
    PlatformConfigView(viewModel: SettingsViewModel(), tutorialAction: {})
        .frame(width : 775)
        .padding()
}
