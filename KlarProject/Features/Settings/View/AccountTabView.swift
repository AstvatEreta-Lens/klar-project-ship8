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
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.sectionHeader)
           
                    
                VStack(alignment : .leading, spacing: 20) {
                    HStack{
                        Text("Profile Picture")
                            .font(.body)
                            .foregroundColor(Color.textRegular)

                        Spacer()

                        if let profile = currentProfile {
                            UserAvatarView(name: avatarName(for: profile))
                                .frame(width: 56, height: 56)
                                .padding(.trailing, 260)
                        } else {
                            UserAvatarView(name: "NA")
                                .frame(width: 56, height: 56)
                        }

                    }
                    usernameRow(text: usernameBinding())
                    
                    fieldRow(title: "Phone Number", text: binding(for: \.phoneNumber))
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

    
    private var currentProfile: UserProfile? {
        guard viewModel.userProfiles.indices.contains(selectedProfileIndex) else { return nil }
        return viewModel.userProfiles[selectedProfileIndex]
    }

    
    private func fieldRow(title: String, text: Binding<String>) -> some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.body)
                .foregroundColor(Color.textRegular)
//                .frame(minWidth: 100)
            Spacer()
            EditableTextBox(text: text)
                .frame(minWidth: 200, maxWidth: 300)
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
    
    private func usernameRow(text: Binding<String>) -> some View {
        HStack(spacing: 6) {
            Text("Username")
                .font(.body)
                .foregroundColor(Color.textRegular)
//                .frame(minWidth: 100)
            Spacer()
            EditableTextBox(text: text)
                .frame(minWidth: 200, maxWidth: 300)
        }
    }
    
    private func usernameBinding() -> Binding<String> {
        Binding(
            get: {
                guard let profile = currentProfile else { return "" }
                let value = profile.username
                return value.hasPrefix("@") ? value : "@\(value)"
            },
            set: { newValue in
                guard viewModel.userProfiles.indices.contains(selectedProfileIndex) else { return }
                let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    viewModel.userProfiles[selectedProfileIndex].username = ""
                } else if trimmed.hasPrefix("@") {
                    viewModel.userProfiles[selectedProfileIndex].username = trimmed
                } else {
                    viewModel.userProfiles[selectedProfileIndex].username = "@\(trimmed)"
                }
            }
        )
    }
    
    private func avatarName(for profile: UserProfile) -> String {
        profile.username.replacingOccurrences(of: "@", with: "")
    }
}

#Preview {
    AccountTabView(viewModel: SettingsViewModel())
        .frame(width: 775)
        .padding()
}
