//
//  ContactContinueButton.swift
//  KlarProject
//
//  Created by Aurelly Joeandani on 20/11/25.
//
import SwiftUI

struct ContactContinueButton : View{
    let contactContinueAction : () -> Void
    
    var body: some View{
        Button(action: contactContinueAction) {
            HStack{
                Text("Continue")
                    .foregroundColor(Color.white)
                    .font(.body)
                    .fontWeight(.light)
                    .frame(minWidth : 599, maxWidth: .infinity, minHeight : 36, maxHeight: .infinity, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .foregroundColor(Color.sectionHeader)
                            
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(11)
        .padding(.bottom, 24)
    }
}

#Preview{
    ContactContinueButton(contactContinueAction: {})
        .frame(width : 599, height : 36)
        .padding()
}
