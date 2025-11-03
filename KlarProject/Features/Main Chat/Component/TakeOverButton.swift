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
            HStack(spacing: 8) {
                Text("Take Over")
                    .foregroundColor(Color.white)
                    .font(.body)
                    .fontWeight(.light)
            }
            .frame(width: 595, height: 36)
            .background(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.borderColor, location: 0.01),
                        .init(color: Color.secondaryTextColor, location: 1.0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(11)
            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview{
    TakeOverButton(takeoverAction: {})
        .padding()
}
