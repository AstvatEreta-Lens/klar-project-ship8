//
//  AddButton.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 01/11/25.
//

import SwiftUI

struct AddButton: View {
    let addLabelImage: String
    let action: () -> Void
    let isSelected: Bool = true
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: addLabelImage)
                    .foregroundColor(Color.labelTextColor)
                    .font(.caption)
                Text("Add")
                    .foregroundColor(Color.labelTextColor)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(Color.sectionHeader)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 10) {
        AddButton(addLabelImage: "tag.fill") {
            print("Tag Fill Button Clicked")
        }
        AddButton(addLabelImage: "person.fill.badge.plus") {
            print("Person Badge Button Clicked")
        }
    }
    .padding()
}
