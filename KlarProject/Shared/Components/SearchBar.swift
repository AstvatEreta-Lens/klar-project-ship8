//
//  SearchBar.swift (Custom Placeholder Version)
//  KlarProject
//
//  Created by Nicholas Tristandi on 22/10/25.
//

import SwiftUI

struct SearchBar : View {
    @Binding var text : String
    
    var placeholder: String = NSLocalizedString("Search...", comment: "")
    var onSearch: () -> Void = {}
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.primaryTextColor)
                .font(.caption)
                .padding(.leading, 10)
                .accessibilityHidden(true)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(hex : "#4D4D4D"))
                        .font(.caption)
                        .accessibilityHidden(true)
                }

                // TextField
                TextField("", text: $text)
                    .foregroundStyle(Color.black)
                    .font(.body)
                    .onSubmit(onSearch)
                    .textFieldStyle(PlainTextFieldStyle())
                    .accessibilityLabel(placeholder)
                    .accessibilityHint("Enter text to search")
            }
            .padding(.trailing, 10)
        }
        .padding(.top, 6.5)
        .padding(.bottom, 6.5)
        
        .background(Color(hex : "#F5F5F5"))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        // Default placeholder
        SearchBar(text: .constant(""))
        
        // With text
        SearchBar(text: .constant("Test search"))
    }
    .padding()
}
