//
//  TakeOverButton.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI

struct TakeOverButton : View{
    let takeoverAction : () -> Void
    
    var body: some View{
        Button(action: takeoverAction) {
            HStack{
                Text("Take Over")
                    .foregroundColor(Color.white)
                    .font(.body)
                    .fontWeight(.light)
                    .frame(minWidth : 599, maxWidth: .infinity, minHeight : 36, maxHeight: .infinity, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .foregroundColor(Color(hex : "#3590A2"))
                            
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(11)
        .padding(.bottom, 24)
    }
}

#Preview{
    TakeOverButton(takeoverAction: {})
        .frame(width : 599, height : 36)
        .padding()
}
