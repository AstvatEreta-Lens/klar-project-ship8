//
//  ChatHandledByAI.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/11/25.
//

import SwiftUI
import SwiftUI

struct ChatHandledByAI: View {
    @State private var resolvedChats: Int = 0
    let targetChats: Int = 48
    let improvementPercent: Double = 12.0

    var body: some View {
        VStack(spacing: 10) {
            
            // Indicator
            HStack(spacing: 6) {
                Image(systemName: improvementPercent >= 0 ? "arrow.up.right" : "arrow.down.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                Text("\(String(format: "%.0f", improvementPercent))%")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(Color.sectionHeader)

            // Title
            Text("Chat Resolved Today")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "#1A1A1A"))
            
            // Animated counter
            Text("\(resolvedChats)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(Color.sectionHeader)
                .shadow(color: Color.black.opacity(0.15), radius: 4, y: 2)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: resolvedChats)
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white,
                    Color(hex: "#E7F4F5")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.sectionHeader.opacity(0.5), lineWidth: 1.2)
        )
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
//        .padding()
        .onAppear {
            withAnimation {
                resolvedChats = targetChats
            }
        }
    }
}

#Preview {
    ChatHandledByAI()
}
