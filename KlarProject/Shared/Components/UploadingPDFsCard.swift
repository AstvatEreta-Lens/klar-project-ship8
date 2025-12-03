

//
//  UploadingPDFsCard.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 15/11/25.
//

import SwiftUI

struct UploadingPDFsCard: View {
    
    let fileName: String
    let progress: Double
    let isCompleted: Bool
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Image("Group 11")
                .resizable()
                .frame(width: 24, height: 26)
            
            Text(displayFileName + ".pdf")
                .foregroundColor(Color.textRegular)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.middle)
            
            Spacer()
            
            if isCompleted {
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.textRegular)
                        .font(.system(size: 12))
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                ProgressView(value: progress, total: 1.0)
                    .tint(Color.sectionHeader)
                    .progressViewStyle(.circular)
            }
        }
        .padding(.horizontal, 12)
        .frame(width: 229, height: 39)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.sectionHeader, lineWidth: 1)
        )
    }
    
    private var displayFileName: String {
        // Remove .pdf extension for display
        if fileName.hasSuffix(".pdf") {
            return String(fileName.dropLast(4))
        }
        return fileName
    }
}

#Preview {
    VStack(spacing: 10) {
        UploadingPDFsCard(
            fileName: "Sample Document.pdf",
            progress: 0.3,
            isCompleted: false,
            onRemove: {}
        )
        
        UploadingPDFsCard(
            fileName: "Very Long File Name That Should Truncate.pdf",
            progress: 0.7,
            isCompleted: false,
            onRemove: {}
        )
        
        UploadingPDFsCard(
            fileName: "Completed File.pdf",
            progress: 1.0,
            isCompleted: true,
            onRemove: {}
        )
    }
    .padding()
}
