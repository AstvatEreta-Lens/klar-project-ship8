//
//  HumanConversationItemView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/10/25.
//

import SwiftUI

struct HumanConversationItemView: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Image(conversation.profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                // WhatsApp badge
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
            
            // Name and Message
            VStack(alignment: .leading, spacing: 5) {
                Text(conversation.name)
                    .font(.system(size: 12))
                    .foregroundColor(Color.blackSecondary)
                
                Text(conversation.message)
                    .font(.system(size: 11))
                    .foregroundColor(Color.grayTextColor)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Time and Unread Count
            VStack(alignment: .trailing, spacing: 4) {
                Text(conversation.time)
                    .font(.system(size: 12))
                    .foregroundColor(conversation.unreadCount > 0 ? .blue : .grayTextColor)
                
                if conversation.unreadCount > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 24, height: 24)
                        
                        Text("\(conversation.unreadCount)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
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
        HumanConversationItemView(conversation: Conversation.dummyData[0])
        HumanConversationItemView(conversation: Conversation.dummyData[1])
        HumanConversationItemView(conversation: Conversation.dummyData[2])
    }
    .padding(10)
}
