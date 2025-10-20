//
//  MainConversationView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 18/10/25.
//

import SwiftUI

struct MainConversationView: View {
    @State private var messageText = ""
       
       var body: some View {
           VStack(spacing: 0) {
               // Top Bar
               TopBarConversationView()
               
               Divider()
               
               // Messages Area
               ScrollView {
                   VStack(spacing: 12) {
                       // Placeholder untuk messages
                       Text("Messages akan muncul di sini")
                           .foregroundColor(.secondary)
                           .padding(.top, 20)
                       
                       
                   }
                   .frame(maxWidth: .infinity)
                   .padding()
               }
               .background(Color(nsColor: .controlBackgroundColor))
               
               Divider()
               
               // Input Area
               HStack(spacing: 12) {
                   // Text Input
                   HStack {
                       TextField("Type a message...", text: $messageText, axis: .vertical)
                           .textFieldStyle(.plain)
                           .font(.system(size: 14))
                           .lineLimit(1...5)
                           .padding(.horizontal, 12)
                           .padding(.vertical, 10)
                   }
                   .background(
                       RoundedRectangle(cornerRadius: 8)
                           .fill(Color.gray.opacity(0.1))
                   )
                   
                   // Send Button
                   Button(action: {
                       // Action untuk mengirim message
                       sendMessage()
                   }) {
                       Image(systemName: "paperplane.fill")
                           .font(.system(size: 16))
                           .foregroundColor(.white)
                           .frame(width: 36, height: 36)
                           .background(
                               Circle()
                                   .fill(messageText.isEmpty ? Color.gray : Color.blue)
                           )
                   }
                   .buttonStyle(.plain)
                   .disabled(messageText.isEmpty)
               }
               .padding(.horizontal, 16)
               .padding(.vertical, 12)
               .background(Color(nsColor: .windowBackgroundColor))
           }
           .frame(maxWidth: .infinity, maxHeight: .infinity)
       }
       
       private func sendMessage() {
           guard !messageText.isEmpty else { return }
           // Logic untuk mengirim message
           print("Sending message: \(messageText)")
           messageText = ""
       }
   }


#Preview {
    MainConversationView()
}
