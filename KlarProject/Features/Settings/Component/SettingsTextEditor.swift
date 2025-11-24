//
//  SettingsTextEditor.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 12/11/25.
//
import SwiftUI

struct EditableTextBox: View {
    @Binding var text: String
//    var placeholder: String
    private let minHeight: CGFloat = 36
    private let maxHeight: CGFloat = 80
    
    var body: some View {
        ZStack(alignment: .leading){
            if text.isEmpty {
                Text("No Data")
                    .foregroundColor(.gray.opacity(0.5))
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 11)
            }
            
            TextEditor(text: $text)
                .foregroundColor(Color.primaryTextColor)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 11)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .frame(height: minHeight)
        .background(Color.white)
        .cornerRadius(11)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.sectionHeader, lineWidth: 1)
        )
    }
}


#Preview("Empty") {
    @Previewable @State var text = ""
    
    EditableTextBox(text: $text)
        .padding()
        .frame(width: 249)
}

#Preview("With Text") {
    @Previewable @State var text = "NicholasTristandi"
    
    EditableTextBox(text: $text)
        .padding()
        .frame(width: 249)
}

