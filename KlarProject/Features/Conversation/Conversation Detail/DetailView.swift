//
//  DetailView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/10/25.
//

import SwiftUI

struct ChatDetailView: View {
    let conversation : Conversation
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header - Customer Name & WhatsApp
                    VStack(alignment: .leading) {
                        Text(conversation.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color.blackSecondary)
                            .padding(.bottom, 1)
                        
                        Text(conversation.phoneNumber)
                            .font(.system(size: 12))
                            .underline(true)
                            .foregroundColor(Color.greySecondary)
                            .padding(.bottom, 9)
                        
                        HStack(spacing: 16) {
                            Image(systemName: "message.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.green)
                            Text("WhatsApp")
                                .font(.system(size: 12))
                                .foregroundColor(Color.greySecondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 18)
                    
                    Divider()
                        .padding(.horizontal, 14)
                        .padding(.top, 12)
                        .foregroundColor(Color.dividerColor)
                    
                    // Handled By & Status
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("HANDLED BY")
                                .font(.system(size: 12))
                                .foregroundColor(Color.grayTextColor)
                            
                            HStack(spacing: 8) {
                                Image("Pak Lu Hoot")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle())
                                
                                VStack() {
                                    Text(conversation.handlerType == .ai ? "Ai Assistant" : "Pak Lu Hoot")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.grayTextColor)
                                    Text(conversation.time)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("STATUS")
                                .font(.system(size: 12))
                                .foregroundColor(Color.grayTextColor)
                            
                            // Status Type
                            if let status = conversation.status {
                                Status(type: status)
                            } else {
                                Text("Active")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 2)
                                    .background(Color.blue)
                                    .cornerRadius(11)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    
                    Divider()
                        .padding(.horizontal, 14)
                        .padding(.top, 12)
                        .foregroundColor(Color.dividerColor)
                    
                    // Seen By
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SEEN BY")
                            .font(.system(size: 12))
                            .foregroundColor(Color.grayTextColor)
                        
                            HStack(spacing: 8) {
                                Image("Pak Lu Hoot")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Ninda")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.grayTextColor)
                                    Text(conversation.time)
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.grayTextColor)
                                }
                                
                                Spacer()
                            }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    
                    Divider()
                        .padding(.horizontal, 14)
                        .padding(.top, 12)
                        .foregroundColor(Color.dividerColor)
                    
                    // Internal Notes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("INTERNAL NOTES")
                            .font(.system(size: 12))
                            .foregroundColor(Color.grayTextColor)
                            .padding(.horizontal, 14)
                        
                        // Space untuk internal notes chat
                        InternalNotes()
                        .padding(.horizontal, 10)
                    }
                    .padding(.vertical, 16)
                }
            }
            
            // Control Buttons
            VStack(spacing: 11) {
                Text("CONTROL")
                    .font(.system(size: 12))
                    .foregroundColor(Color.grayTextColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    // Action create ticket
                    print("Create Button Clicked")
                }) {
                    Text("Create Ticket")
                        .font(.system(size: 11))
                        .foregroundColor(.black)
                        .frame(width: 257, height : 36)
                        .padding(.vertical, 0.5)
                        .background(Color.white)
                        .cornerRadius(11)
                        .overlay(
                            RoundedRectangle(cornerRadius : 11)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    // Action resolve
                    print("Resolve Button Clicked")
                }) {
                    Text("RESOLVE")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 257, height : 36)
                        .padding(.vertical, 0.5)
                        .background(Color.chosenColor)
                        .cornerRadius(11)
                        .overlay(
                            RoundedRectangle(cornerRadius: 11)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
        }
        .frame(width: 290, height : 912)
        .overlay(
            // Atur corner corner
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

// Model untuk Seen By
struct SeenBy: Identifiable {
    let id = UUID()
    let name: String
    let time: String
    let image: String
}

#Preview {
    ChatDetailView(conversation: Conversation.dummyData[0])
}
