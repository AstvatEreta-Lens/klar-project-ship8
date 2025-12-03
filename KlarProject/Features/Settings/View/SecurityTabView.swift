//
//  SecurityTabView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 12/11/25.
//

import SwiftUI

struct SecurityTabView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedProfileIndex: Int = 0
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Security")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.sectionHeader)
           
                    
                VStack(alignment : .trailing, spacing: 20) {
                    fieldRow(title: NSLocalizedString("Workspace Email", comment : ""), text: binding(for: \.workSpaceEmail))
                    fieldRow(title: NSLocalizedString("Role", comment : ""), text: binding(for: \.role))
                    fieldRow(title: NSLocalizedString("Password", comment :""), text: binding(for: \.password))
                    fieldRow(title: NSLocalizedString("PIN", comment : ""), text: binding(for: \.PIN))
                    }
                    .padding(20)
                    .background(Color.backgroundPrimary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.sectionHeader, lineWidth: 1)
                    )
            }
    }
    
    private var security: SecurityProperties? {
        guard viewModel.securityProperties.indices.contains(selectedProfileIndex) else { return nil }
        return viewModel.securityProperties[selectedProfileIndex]
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
    }
    
    private func binding(for keyPath: WritableKeyPath<SecurityProperties, String>) -> Binding<String> {
        Binding(
            get: {
                guard let securityProperties = security else { return "" }
                return securityProperties[keyPath: keyPath]
            },
            set: { newValue in
                guard viewModel.securityProperties.indices.contains(selectedProfileIndex) else { return }
                viewModel.securityProperties[selectedProfileIndex][keyPath: keyPath] = newValue
            }
        )
    }
}

#Preview {
    SecurityTabView(viewModel: SettingsViewModel())
        .frame(width : 775)
        .padding()
}
