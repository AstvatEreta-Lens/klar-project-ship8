//
//  ResolveButton.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI

struct ResolveButton: View {
    let resolveAction: () -> Void
    
    var body: some View {
        Button(action: resolveAction) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.borderColor)
                    .font(.body)
                
                Text("Mark Resolved")
                    .foregroundColor(Color.borderColor)
                    .font(.body)
                    .fontWeight(.medium)
            }
            .frame(minWidth: 307, maxWidth: .infinity,minHeight: 36, maxHeight: .infinity, alignment: .center)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.42, green: 0.68, blue: 0.74),
                        Color(red: 0.25, green: 0.48, blue: 0.55)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(11)
            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ResolveButton(resolveAction: {
        print("Resolved tapped")
    })
    .frame(width: 307, height: 36)
    .padding()
    .background(Color.white)
}
