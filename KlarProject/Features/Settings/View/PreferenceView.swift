//
//  PreferenceView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/11/25.
//

import SwiftUI

struct PreferenceView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @State private var selectedTheme : AppTheme = .system

    var body: some View {
        VStack(alignment : .leading, spacing : 16){
            Text(NSLocalizedString("Preference", comment: ""))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.sectionHeader)


            VStack(alignment : .leading, spacing : 20){
                HStack{
                    Text(NSLocalizedString("Theme", comment: ""))
                        .foregroundColor(Color.primaryTextColor)
                        .font(.body)
                        .fontWeight(.bold)

                    Spacer()
                            Picker("", selection: $selectedTheme){
                                ForEach(AppTheme.allCases){
                                    theme in
                                    Text(theme.rawValue)
                                        .foregroundColor(Color.textRegular)
                                        .tag(theme)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .tint(Color.sectionHeader)
                        }

                HStack{
                    Text(NSLocalizedString("Language", comment: ""))
                        .foregroundColor(Color.textRegular)
                        .font(.body)
                        .fontWeight(.bold)

                    Spacer()

                        Picker("", selection: $languageManager.currentLanguage){
                            ForEach(Language.allCases){
                                language in
                                Text(language.displayName)
                                    .foregroundColor(Color.textRegular)
                                    .tag(language)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .tint(Color.sectionHeader)

                }
            }
            .padding(20)
            .background(Color.bakcgroundPrimary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
        }
        .padding(.bottom, 10)
    }
}


enum AppTheme : String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case system = "System Default"

    var id: String{self.rawValue}
}

#Preview {
    PreferenceView()
        .padding()
}
