//
//  DummyPage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/10/25.
//

import SwiftUI

struct DummyPageView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Chat area (scrollable)
            ScrollView {
                Image("Photo Profile")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity)
            
            Divider()
            
            // Bottom button
            Button(action: {
                print("Take Over Button Clicked")
            }) {
                Text("Take Over")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    DummyPageView()
        .frame(width: 600, height: 900)
}
