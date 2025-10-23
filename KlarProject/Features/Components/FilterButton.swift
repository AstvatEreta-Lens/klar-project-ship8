//
//  FilterButton.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 22/10/25.
//

import SwiftUI

struct FilterButton: View {
    let title: String
    var count: Int? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 11))
                
                if let count = count {
                    Text("\(count)")
                        .font(.system(size: 11))
                }
            }
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .background(isSelected ? Color.chosenColor : Color.white)
            .cornerRadius(36)
            .overlay(
                RoundedRectangle(cornerRadius: 36)
                    .stroke(Color.black)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing : 3){
        FilterButton(title: "All", count: nil, isSelected: true, action: {})
        FilterButton(title: "Unread", count: 2, isSelected: false, action: {})
        FilterButton(title: "Unresolved", count: 2, isSelected: false, action: {})
    }
    .padding(10)
}
