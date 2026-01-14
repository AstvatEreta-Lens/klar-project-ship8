//
//  EvaluateButton.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 07/11/25.
//


import SwiftUI

struct EvaluateButton: View {
    let evaluateAction: () -> Void
    
    var body: some View {
        Button(action: evaluateAction) {
            HStack(spacing: 8) {
                Image(systemName: "pencil.and.list.clipboard")
                    .foregroundColor(Color.secondaryText)
                    .font(.body)
                
                Text("Evaluate this conversation")
                    .foregroundColor(Color.secondaryText)
                    .font(.body)
            }
            .frame(minWidth: 307, maxWidth: .infinity,minHeight: 36, maxHeight: .infinity, alignment: .center)
            .background(
                Color.white
            )
            .cornerRadius(11)
            .overlay(
                RoundedRectangle(cornerRadius: 11)
                    .stroke(Color.secondaryText, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    EvaluateButton(evaluateAction:  {
        print("Evaluation tapped")
    })
    .frame(width: 307, height: 36)
    .padding()
    .background(Color.white)
}
