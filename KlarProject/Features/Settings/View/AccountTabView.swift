//
//  AccountTabView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 12/11/25.
//

import SwiftUI

struct AccountTabView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedProfileIndex: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.sectionHeader)
           
                    
                VStack(alignment : .trailing, spacing: 20) {
                        HStack(alignment: .top) {
                            Text("Profile Picture")
                                .font(.body)
                                .foregroundColor(Color.textRegular)
                                
                            Spacer()
                            Image("Pak Lu Hoot")
                                .resizable()
                                .frame(width: 56, height: 56)
                                .clipShape(Circle())
                        }
                        fieldRow(title: "Username", text: binding(for: \.username))
                        fieldRow(title: "Phone Number", text: binding(for: \.phoneNumber))
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.sectionHeader, lineWidth: 1)
                    )
            }
            Spacer()
        }

    
    private var currentProfile: UserProfile? {
        guard viewModel.userProfiles.indices.contains(selectedProfileIndex) else { return nil }
        return viewModel.userProfiles[selectedProfileIndex]
    }

    
    private func fieldRow(title: String, text: Binding<String>) -> some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.body)
                .foregroundColor(Color.textRegular)
            Spacer()
            EditableTextBox(text: text)
                .frame(width : 249)
        }
    }
    
    private func binding(for keyPath: WritableKeyPath<UserProfile, String>) -> Binding<String> {
        Binding(
            get: {
                guard let profile = currentProfile else { return "" }
                return profile[keyPath: keyPath]
            },
            set: { newValue in
                guard viewModel.userProfiles.indices.contains(selectedProfileIndex) else { return }
                viewModel.userProfiles[selectedProfileIndex][keyPath: keyPath] = newValue
            }
        )
    }
}

#Preview {
    AccountTabView(viewModel: SettingsViewModel())
        .frame(width: 775)
        .padding()
}
