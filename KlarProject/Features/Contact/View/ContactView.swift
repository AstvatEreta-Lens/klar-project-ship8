//
//  ContactView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 17/11/25.
//

import SwiftUI

struct ContactTableView: View {
    
    @State var conversations: [Conversation]
    @State private var selectedContact: Conversation?
    
    // Callback untuk handle selection
    var onContactSelected: ((Conversation) -> Void)?
    
    init(conversations: [Conversation]? = nil, onContactSelected: ((Conversation) -> Void)? = nil) {
        // Jika tidak ada data yang diberikan, gunakan semua data dummy
        let allConversations = conversations ?? (Conversation.humanDummyData + Conversation.aiDummyData)
        _conversations = State(initialValue: allConversations)
        self.onContactSelected = onContactSelected
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                headerRow(width: geometry.size.width)
        
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(conversations.enumerated()), id: \.element.id) { index, conversation in
                            ContactRow(
                                number: index + 1,
                                conversation: conversation,
                                isSelected: selectedContact?.id == conversation.id,
                                totalWidth: geometry.size.width
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedContact = conversation
                                onContactSelected?(conversation)
                            }
                        }
                    }
                }
                .frame(minHeight: 100)
            }
            .padding(.horizontal, 2)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    func headerRow(width: CGFloat) -> some View {
        HStack(spacing: 0) {
            headerText("No.")
                .frame(width: width * 0.05, alignment: .center) // 5%
            
            headerText("Name")
                .frame(width: width * 0.15, alignment: .center) // 15%
            
            headerText("Phone Number")
                .frame(width: width * 0.18, alignment: .center) // 18%
            
            headerText("Channel")
                .frame(width: width * 0.15, alignment: .center) // 15%
            
            headerText("Address")
                .frame(width: width * 0.32, alignment: .center) // 32%
            
            headerText("Tags")
                .frame(width: width * 0.15, alignment: .center) // 15%
        }
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.06))
    }
    
    func headerText(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.gray)
    }
}

struct ContactRow: View {
    let number: Int
    let conversation: Conversation
    let isSelected: Bool
    let totalWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(number)")
                .foregroundColor(Color.textRegular)
                .frame(width: totalWidth * 0.05, alignment: .center) // 5%
            
            Text(conversation.name)
                .foregroundColor(Color.textRegular)
                .frame(width: totalWidth * 0.15, alignment: .center) // 15%
                .lineLimit(1)
            
            Text(conversation.phoneNumber)
                .foregroundColor(Color.textRegular)
                .frame(width: totalWidth * 0.18, alignment: .center) // 18%
                .lineLimit(1)
            
            HStack(spacing: 6) {
                Image(systemName: channelIcon)
                    .foregroundColor(.green)
                Text(channelName)
                    .foregroundColor(Color.textRegular)
            }
            .frame(width: totalWidth * 0.15, alignment: .center) // 15%
            
            Text("-") // Address kosong sementara
                .frame(width: totalWidth * 0.32, alignment: .center) // 32%
                .foregroundColor(.gray.opacity(0.5))
            
            // Display tags/labels
            Text(tagsText)
                .foregroundColor(Color.textRegular)
                .frame(width: totalWidth * 0.15, alignment: .center) // 15%
                .lineLimit(1)
        }
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.white)
        .overlay(
            Rectangle()
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
        )
    }
    
    // Helper computed properties
    private var channelIcon: String {
        conversation.hasWhatsApp ? "message.circle.fill" : "envelope.circle.fill"
    }
    
    private var channelName: String {
        conversation.hasWhatsApp ? "WhatsApp" : "Email"
    }
    
    private var tagsText: String {
        if conversation.label.isEmpty {
            return "-"
        }
        return conversation.label.map { $0.rawValue }.joined(separator: ", ")
    }
}

#Preview {
    // Preview dengan dummy data dari Conversation model
    ContactTableView(
        conversations: Conversation.humanDummyData + Conversation.aiDummyData,
        onContactSelected: { conversation in
            print("Selected: \(conversation.name)")
        }
    )
    .frame(height: 400)
    .padding()
}
