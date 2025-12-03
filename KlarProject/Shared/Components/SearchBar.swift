//
//  SearchBar.swift (Custom Placeholder Version)
//  KlarProject
//
//  Created by Nicholas Tristandi on 22/10/25.
//

import SwiftUI

struct SearchBar : View {
    @Binding var text : String
    @FocusState private var isFocused: Bool

    var placeholder: String = NSLocalizedString("Search...", comment: "")
    var onSearch: () -> Void = {}

    var body: some View {
        HStack(spacing: 8) {
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
                        .allowsHitTesting(false)
                }

                // TextField
                TextField("", text: $text)
                    .foregroundStyle(Color.black)
                    .font(.body)
                    .focused($isFocused)
                    .onSubmit(onSearch)
                    .onChange(of: text) { oldValue, newValue in
                        onSearch()
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .accessibilityLabel(placeholder)
                    .accessibilityHint("Enter text to search")
            }
            .padding(.trailing, 10)
        }
        .padding(.top, 6.5)
        .padding(.bottom, 6.5)
//        .background(Color(hex : "#F5F5F5"))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
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
