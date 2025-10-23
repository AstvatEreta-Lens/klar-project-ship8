//
//  ChatKlarView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

struct ChatKlarView: View {
    @State private var selectedConversation: Conversation? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            ConversationListView(selectedConversation: $selectedConversation)
            
            DummyPage()
            
            // Chat Detail
            if let conversation = selectedConversation {
                ChatDetailView(conversation: conversation)
            } else {
                // Placeholder ketika belum ada yang dipilih
                VStack {
                    Text("Silahkan Pilih Chat")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .frame(width: 290, height: 912)
                .overlay(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 12,
                        topTrailingRadius: 12
                    )
                    .stroke(style: StrokeStyle(lineWidth: 1))
                )
                .background(Color.white)
            }
        }
    }
}

#Preview {
    ChatKlarView()
}
