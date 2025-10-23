//
//  AIConversationView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/10/25.
//
import SwiftUI

struct AIConversationItemView: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image with WhatsApp badge
            ZStack(alignment: .bottomTrailing) {
                Image("Pak Lu Hoot")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                if conversation.hasWhatsApp {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 15, height: 15)
                        
                        Circle()
                            .fill(Color.green)
                            .frame(width: 14, height: 14)
                        
                        Image(systemName: "message.fill")
                            .font(.system(size: 7))
                            .foregroundColor(.white)
                    }
                    .offset(x: 2, y: 2)
                }
            }
            
            // Phone Number and Message
            VStack(alignment: .leading, spacing: 5) {
                Text(conversation.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.blackSecondary)
                
                Text(conversation.message)
                    .font(.system(size: 11))
                    .foregroundColor(Color.grayTextColor)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Time and Status Badge
            VStack(alignment: .trailing, spacing: 4) {
                Text(conversation.time)
                    .font(.system(size: 12))
                    .foregroundColor(.grayTextColor)
                
                // Pakai komponen Status yang sudah ada
                if let status = conversation.status {
                    Status(type: status)
                }
            }
        }
        .frame(width: 275, height: 40, alignment: .leading)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

#Preview {
    VStack(spacing: 1) {
        AIConversationItemView(conversation: Conversation.aiDummy[1])
        AIConversationItemView(conversation: Conversation.aiDummy[1])
        AIConversationItemView(conversation: Conversation.aiDummy[2])
    }
    .padding(10)
}
