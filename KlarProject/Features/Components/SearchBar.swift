//
//  SearchBar.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 22/10/25.
//

import SwiftUI

struct SearchBar : View {
    @Binding var text : String
    
    var onSubmit: () -> Void = {}
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .onSubmit(onSubmit)
                .textFieldStyle(PlainTextFieldStyle())
            
            Button(action: onSubmit) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    .padding(.leading, 12)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(8.5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 1)
        )
        
    }
}

#Preview {
    SearchBar(text: .constant(""), onSubmit: { print("Search submitted") })
        .padding(10)
}
