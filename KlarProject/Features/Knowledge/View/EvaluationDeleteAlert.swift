//
//  EvaluationDeleteAlert.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 14/11/25.
//

import SwiftUI

struct DeletePDFAlert: View {
    let pdfDocument: PDFDocument
    let deleteAction: () -> Void
    let cancelAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text("Are you sure want to delete this file?")
                .foregroundColor(Color.textRegular)
                .font(.body)
                .fontWeight(.bold)
                .padding(.top, 24)
            
            // Placeholder card - Preview PDF yang akan dihapus
            VStack {
                HStack {
                    ZStack(alignment: .bottom){
                        Image("Group 12")
                            .font(.title)
                            .foregroundColor(Color.sectionHeader)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(pdfDocument.title + ".pdf")
                            .font(.caption)
                            .foregroundColor(Color.textRegular)
//                        Text(pdfDocument.formattedDateAdded)
//                            .font(.caption)
//                            .foregroundColor(Color.avatarCount)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .background(Color.backgroundPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(Color.sectionHeader, lineWidth: 1)
                )
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 8)
            
            
            Spacer()
//                .frame(height: 20)
            // Warning text
            Text("Deleted files cannot be backup unless you download it on your computer. This action cannot be undone.")
                .font(.caption)
                .foregroundColor(Color.textRegular)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
            
            
            // Delete button
            Button(action: deleteAction) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(Color.textRegular)
                    Text("Delete")
                        .foregroundColor(Color.textRegular)
                        .font(.body)
                        .fontWeight(.bold)
                }
                .frame(width: 308, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 11)
                        .foregroundColor(Color.redStatus)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .cornerRadius(11)
            
            // Cancel button
            Button(action: cancelAction) {
                Text("Cancel")
                    .foregroundColor(Color.sectionHeader)
                    .frame(width: 308, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .foregroundColor(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(Color.sectionHeader, lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 24)
        }
        .frame(width: 341, height: 372)
        .background(Color.backgroundPrimary)
        .cornerRadius(11)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.sectionHeader, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}


#Preview {
    DeletePDFAlert(
        pdfDocument: PDFDocument.dummyPDFs[0],
        deleteAction: {
            print("Delete confirmed")
        },
        cancelAction: {
            print("Delete cancelled")
        }
    )
    .padding()
}
