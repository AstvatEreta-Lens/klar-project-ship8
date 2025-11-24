//
//  DetailView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/10/25.
//

import SwiftUI

struct ChatDetailView: View {
    let conversation: Conversation
    
    var body: some View {
        VStack {
//            ScrollView {
                VStack{
                    Image(conversation.profileImage)
                        .resizable()
                        .frame(width: 59, height: 59)
                        .clipShape(Circle())
                        .padding(.top, 36)
                        .padding(.bottom)
                    
                    // Header - Customer Name & WhatsApp
                    VStack {
                        Text(conversation.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.blackSecondary)
                        
                        Text(conversation.phoneNumber)
                            .font(.system(size: 12))
                            .underline(true)
                            .foregroundColor(Color.greySecondary)
                            .padding(.bottom, 2)
                        
                        HStack {
                            Image("whatsapp")
                                .resizable()
                                .frame(width: 14, height: 14)
                                .clipShape(Circle())
                                .foregroundColor(.green)
                            
                            Text("WhatsApp")
                                .font(.system(size: 12))
                                .foregroundColor(Color.greySecondary)
                        }
                    }
                    .padding(.horizontal, 13)
                    
                    
                    CustomDivider()
                        .padding(.top, -3)
                    
                    // Handled By & Status
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Last Handled By")
                                .font(.caption)
                                .foregroundColor(Color.primaryUsernameText)
                            
                            HandledBySection(
                                user: conversation.handledBy,
                                time: conversation.handledAt,
                                handlerType: conversation.handlerType,
                                status: conversation.status
                            )
                        }
                        .padding(.leading, 13)
                        Spacer()
                        
                        
                        VStack(alignment: .leading) {
                            Text("Collaborators")
                                .font(.caption)
                                .foregroundColor(Color.primaryUsernameText)
                            
                            CollaboratorsSection(
                                collaborators: conversation.collaborators,
                                onAddCollaborator: {
                                    print("Add collaborator tapped")
                                }
                            )
                        }
                        .padding(.trailing)
                    }
                    
                    CustomDivider()
                
                    HStack{
                        VStack(alignment: .leading){
                            Text("Label")
                                .font(.caption)
                                .foregroundColor(Color.primaryUsernameText)
                            
                            if let label = conversation.label {
                                LabelView(label: label, action: {
                                    print("Label tapped: \(label)")
                                })
                            }
                        }
                        .padding(.leading, 12)
                        Spacer()
                        
                        
                        AddButton(addLabelImage: "tag.fill") {
                            print("Tag Fill Button Clicked")
                        }
                        .padding(.trailing, 14)
                    }
                    
                    CustomDivider()
                    
                    // Internal Notes
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("INTERNAL NOTES")
                                .font(.system(size: 12))
                                .foregroundColor(Color.black)
                                .padding(.leading, 13)
                            
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color.black)
                        }
                        
                        // Space untuk internal notes chat
                        InternalNotesView(
                            conversationId: conversation.id,
                            currentUser: User(name: "Current Admin", profileImage: "") 
                        )
                        .padding(.horizontal, 16)
                        
                        HStack {
                            Text("SUMMARY")
                                .font(.system(size: 12))
                                .foregroundColor(Color.black)
                                .padding(.leading, 13)
                            
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color.black)
                        }
                        
                        Summary(generateAISummary: {})
                            .padding(.leading, 14)
//                    }
                }
            }
        }
        .frame(minWidth: 334, maxHeight: .infinity, alignment : .top)
        .background(Color.white)
    }
}

#Preview {
    ChatDetailView(conversation: Conversation.humanDummyData[0])
        .frame(width : 334)
}
