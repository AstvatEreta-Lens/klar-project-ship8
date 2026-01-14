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
    
    var body: some View {
        HStack{
            HStack{
                ZStack(alignment: .bottom){
                    Image(systemName: "clipboard.fill")
                        .font(.title)
                        .foregroundColor(Color.sectionHeader)
                    Text("PDF")
                        .font(.system(size: 8))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.bottom, 2)
                }
                
                VStack(alignment : .leading){
                    Text(pdfDocument.title + ".pdf")
                        .font(.caption)
                        .foregroundColor(Color.textRegular)
                    Text(pdfDocument.formattedDateAdded)
                        .font(.caption)
                        .foregroundColor(Color.avatarCount)
                }
                
                Spacer()
                
                Button(action : action){
                    Image(systemName: "ellipsis")
                        .rotationEffect(Angle(degrees: 90))
                        .foregroundColor(Color.black)
                }
                .buttonStyle(PlainButtonStyle())
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
