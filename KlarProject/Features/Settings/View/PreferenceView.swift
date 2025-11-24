//
//  PreferenceView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/11/25.
//

import SwiftUI

struct PreferenceView: View {
    @State private var selectedTheme : AppTheme = .system
    @State private var selectedLanguage : Language = .en
    
    var body: some View {
        VStack(alignment : .leading, spacing : 16){
            Text("Preference")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.sectionHeader)
            
            
            VStack(alignment : .leading, spacing : 20){
                HStack{
                    Text("Theme")
                        .foregroundColor(Color.textRegular)
                        .font(.body)
                        .fontWeight(.bold)
                    
                    Spacer()
                            Picker("", selection: $selectedTheme){
                                ForEach(AppTheme.allCases){
                                    theme in
                                    Text(theme.rawValue)
                                        .tag(theme)
                                }
                            }
                        }
                
                HStack{
                    Text("Language")
                        .foregroundColor(Color.textRegular)
                        .font(.body)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                        Picker("", selection: $selectedLanguage){
                            ForEach(Language.allCases){
                                theme in
                                Text(theme.rawValue)
                                    .tag(theme)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.sectionHeader, lineWidth: 1)
            )
        }
        .padding(.bottom, 10)
    }
}


enum Language : String, CaseIterable, Identifiable {
    case en = "English"
    case id = "Bahasa Indonesia"
    var id: String { self.rawValue }
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
