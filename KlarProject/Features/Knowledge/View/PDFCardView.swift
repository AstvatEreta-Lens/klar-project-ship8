//
//  PDFCardView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import SwiftUI

struct PDFCardView: View {
    let pdfDocument: PDFDocument
    let action: () -> Void
    var isSelected: Bool = false
    @State private var showActionButtons: Bool = false
    
    var body: some View {
        HStack{
            HStack{
                ZStack(alignment: .bottom){
                    Image("Group 12")
                        .font(.title)
                        .foregroundColor(Color.sectionHeader)
                }
                
                VStack(alignment : .leading){
                    Text(pdfDocument.title + ".pdf")
                        .font(.body)
                        .foregroundColor(Color.textRegular)
                    Text(pdfDocument.formattedDateAdded)
                        .font(.caption)
                        .foregroundColor(Color.avatarCount)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showActionButtons.toggle()
                    }
                }){
                    Image(systemName: "ellipsis")
                        .rotationEffect(Angle(degrees: 90))
                        .foregroundColor(Color.black)
                }
                .buttonStyle(PlainButtonStyle())
                .overlay{
                    if showActionButtons {
                        DeleteAndEditButton(
                            editAction: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showActionButtons = false
                                }
                                // Add edit logic
                                print("Edit PDF: \(pdfDocument.title)")
                            },
                            deleteAction: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showActionButtons = false
                                }
                                action() // Trigger delete action
                            }
                        )
                        .offset(x: -35)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(10)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.chatChosenColor : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

#Preview {
    VStack{
        PDFCardView(pdfDocument: PDFDocument.dummyPDFs[0], action : {}, isSelected : true)
        PDFCardView(pdfDocument: PDFDocument.dummyPDFs[1], action : {}, isSelected : false)
    }
    .frame(width: 300, height: 100)
        .padding()
}
