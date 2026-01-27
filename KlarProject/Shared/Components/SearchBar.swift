//
//  SearchBar.swift (Custom Placeholder Version)
//  KlarProject
//
//  Created by Nicholas Tristandi on 22/10/25.
//

import SwiftUI

struct SearchBar : View {
    @Binding var text : String
    
    var placeholder: String = "Search..."
    var onSearch: () -> Void = {}
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.primaryTextColor)
                .font(.system(size: 15))
                .padding(.leading, 10)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.primaryText)
                        .font(.caption)
                }
                
                // TextField
                TextField("", text: $text)
                    .foregroundStyle(Color.black)
                    .font(.body)
                    .onSubmit(onSearch)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.trailing, 10)
        }
        .padding(.top, 6.5)
        .padding(.bottom, 6.5)
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
