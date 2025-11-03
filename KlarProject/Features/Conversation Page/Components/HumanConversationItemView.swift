//
//  HumanConversationItemView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/10/25.
//

import SwiftUI

struct HumanConversationItemView: View {
    let conversation: Conversation
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack(alignment: .bottomTrailing) {
                    Image(conversation.profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    
                        ZStack {
                            Image("whatsapp")
                                .resizable()
                                .frame(width: 14, height: 14)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        .offset(x: 2, y: 2)
                }
                
                // Name and Message
                VStack(alignment: .leading, spacing: 5) {
                    Text(conversation.name)
                        .font(.body)
                        .foregroundColor(Color.primaryUsernameText)
                    
                    Text(conversation.message)
                        .font(.caption)
                        .foregroundColor(Color.secondaryUsernameText)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Time and Unread Count
                VStack(alignment: .trailing, spacing: 4) {
                    Text(conversation.time)
                        .font(.system(size: 11))
                        .foregroundColor(Color.primaryUsernameText)
                    
                    if conversation.unreadCount > 0 {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 16, height: 16)
                            
                            Text("\(conversation.unreadCount)")
                                .font(.system(size: 8))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .frame(width: 271, height: 40, alignment: .leading)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.chatChosenColor : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 7))
        }
    }
}

#Preview {
    VStack(spacing: 1) {
        HumanConversationItemView(conversation: Conversation.humanDummyData[0], isSelected: false)
        HumanConversationItemView(conversation: Conversation.humanDummyData[1], isSelected: true)
        HumanConversationItemView(conversation: Conversation.humanDummyData[2], isSelected: false)
    }
    .padding(10)
}
