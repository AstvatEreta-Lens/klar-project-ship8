//
//  SearchBar.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 22/10/25.
//

import SwiftUI

struct SearchBar : View {
    @Binding var text : String
    
    var onSearch: () -> Void = {} // Function mencari message atau user
    
    var body: some View {
        HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.primaryTextColor)
                    .font(.system(size: 15))
                    .padding(.leading, 10)
            
            TextField(
                "Search...",
                text: $text,
                )
                .onSubmit(onSearch)
                .textFieldStyle(PlainTextFieldStyle())
            
            Text(text)
                .foregroundColor(Color.primaryTextColor)
                .font(.caption)
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
    SearchBar(text: .constant(""))
        .padding(10)
}
