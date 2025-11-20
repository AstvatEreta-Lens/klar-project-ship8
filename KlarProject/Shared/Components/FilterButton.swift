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
                    .foregroundColor(isSelected ? Color.white : Color.sectionHeader)
                    .font(.caption).fontWeight(.bold)
                
                if let count = count {
                    Text("\(count)")
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            .foregroundColor(isSelected ? Color.bubbleChat : Color.sectionHeader)
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .background(isSelected ? Color.sectionHeader : Color.white)
            .cornerRadius(36)
            .overlay(
                RoundedRectangle(cornerRadius: 36)
                    .stroke(Color.sectionHeader)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing : 3){
        FilterButton(title: "All",isSelected: true, action: {})
        FilterButton(title: "Unread",isSelected: false, action: {})
        FilterButton(title: "Unresolved",isSelected: false, action: {})
    }
    .padding(10)
}
