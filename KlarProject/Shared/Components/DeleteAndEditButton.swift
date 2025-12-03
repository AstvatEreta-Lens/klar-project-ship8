

//
//  DeleteAndEditButton.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 14/11/25.
//

import SwiftUI

struct DeleteAndEditButton: View {
    let editAction : () -> Void
    let deleteAction : () -> Void
    
    var body: some View {
        
        HStack{
            Button(action: deleteAction) {
                Image(systemName: "trash.fill")
                    .frame(width : 13, height : 13)
                    .foregroundColor(Color.textRegular)
                    .background(
                        Circle()
                            .frame(width: 19, height: 19)
                    )
                    .foregroundColor(Color.redStatus)
            }
            .buttonStyle(PlainButtonStyle())
            
            
            Button(action: editAction) {
                Image(systemName: "pencil")
                    .frame(width : 13, height : 13)
                    .foregroundColor(Color.textRegular)
                    .background(
                        Circle()
                            .frame(width: 19, height: 19)
                    )
                    .foregroundColor(Color.yellowStatus)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 5)
    }
}

struct downloadButton : View {
    let downloadAction : () -> Void
    
    var body: some View {
        Button(action: downloadAction) {
            Image(systemName: "square.and.arrow.down")
                .padding(.bottom, 1)
                .frame(width : 13, height : 13)
                .foregroundColor(Color.textRegular)
                .background(
                    Circle()
                        .frame(width: 19, height: 19)
                )
                .foregroundColor(Color.greenStatus)
        }
        
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack{
        DeleteAndEditButton(editAction: {}, deleteAction: {})
        downloadButton(downloadAction: {})
    }
        .padding()
}
