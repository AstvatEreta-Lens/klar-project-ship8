//
//  AIConversationView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/10/25.
//

import SwiftUI

struct AIConversationItemView: View {
    let conversation: Conversation
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing : 12){
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
                
                // Phone Number and Message
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
                
                // Time and Status Badge
                VStack(alignment: .trailing, spacing: 4) {
                    Text(conversation.time)
                        .font(.system(size: 11))
                        .foregroundColor(Color.primaryUsernameText)
                        .padding(.trailing, 13)
                    
                    // Pakai komponen Status yang sudah ada
                    if let status = conversation.status {
                        Status(type: status)
                    }
                }
            }
            .frame(width: 271, height: 40)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.chatChosenColor : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 7))
        }
//        .contentShape(RoundedRectangle(cornerRadius:7))  Make entire area tappable
    }
}

#Preview {
    VStack(spacing: 1) {
        AIConversationItemView(conversation: Conversation.aiDummyData[1], isSelected: false)
        AIConversationItemView(conversation: Conversation.aiDummyData[1], isSelected: true)
        AIConversationItemView(conversation: Conversation.aiDummyData[2], isSelected: false)
    }
    .padding(10)
}
