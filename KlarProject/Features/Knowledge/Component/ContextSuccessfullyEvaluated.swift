//
//  ContextSuccessfullyEvaluated.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 14/11/25.
//

import SwiftUI

struct ContextSuccessfullyEvaluated: View {
    let continueAction: () -> Void
    
    var body: some View {
        VStack {
            Image("Frame 126")
                .font(.system(size: 100))
                .padding(.top, 56)
            
            Spacer()
            
            Text("Context successfully evaluated!")
                .foregroundColor(Color.textRegular)
                .font(.body)
                .fontWeight(.bold)
                .padding(.bottom)
            
            Button(action: continueAction) {
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(width: 291, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .foregroundColor(Color.sectionHeader)
                    )
            }
            .padding(.bottom, 23)
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 341, height: 373)
        .background(
            RoundedRectangle(cornerRadius: 11)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.sectionHeader, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
        
        ContextSuccessfullyEvaluated(
            continueAction: {
                print("Continue tapped")
            }
        )
    }
}
