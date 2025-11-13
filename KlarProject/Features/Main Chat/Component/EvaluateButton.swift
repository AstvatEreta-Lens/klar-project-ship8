//
//  EvaluateButton.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 07/11/25.
//

import SwiftUI

struct EvaluateButton: View {
    let conversation: Conversation?
    let evaluateAction: () -> Void
    
    // Check if conversation is resolved
    private var canEvaluate: Bool {
        conversation?.status == .resolved
    }
    
    var body: some View {
        Button(action: {
            if canEvaluate {
                evaluateAction()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "pencil.and.list.clipboard")
                    .foregroundColor(canEvaluate ? Color.sectionHeader : Color.gray)
                    .font(.body)
                
                Text("Evaluate this conversation")
                    .foregroundColor(canEvaluate ? Color.sectionHeader : Color.gray)
                    .font(.body)
            }
            .frame(minWidth: 307, maxWidth: .infinity, minHeight: 36, maxHeight: .infinity, alignment: .center)
            .background(Color.white)
            .cornerRadius(11)
            .overlay(
                RoundedRectangle(cornerRadius: 11)
                    .stroke(canEvaluate ? Color.sectionHeader : Color.gray, lineWidth: 1)
            )
            .shadow(color: .black.opacity(canEvaluate ? 0.15 : 0.05), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!canEvaluate)
        .opacity(canEvaluate ? 1.0 : 0.5)
    }
}

#Preview("Can Evaluate - Resolved") {
    VStack(spacing: 20) {
        EvaluateButton(
            conversation: Conversation(
                name: "Test Customer",
                message: "Test message",
                time: "14.29",
                profileImage: "Photo Profile",
                unreadCount: 0,
                hasWhatsApp: true,
                phoneNumber: "+61-1123-1123",
                handlerType: .ai,
                status: .resolved,  // ✅ Resolved - Can evaluate
                handledBy: User(name: "AI", profileImage: "", email: "ai@example.com"),
                handledAt: "14.29"
            ),
            evaluateAction: {
                print("Evaluation triggered!")
            }
        )
        .frame(width: 307, height: 36)
        
        Text("Status: Can Evaluate (Resolved)")
            .font(.caption)
            .foregroundColor(.green)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
