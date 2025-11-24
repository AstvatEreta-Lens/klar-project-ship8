//
//  MainContactView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 18/11/25.
//

import SwiftUI

struct MainContactView: View {
    @ObservedObject var contactViewModel : ConversationListViewModel
    
    let addContactAction : () -> Void
    
    var body: some View {
        VStack(alignment : .leading){
            Text("Contact")
                .font(.largeTitle)
                .foregroundColor(Color.sectionHeader)
            
            HStack{
                Button(action : addContactAction){
                    Image("Add Contact Button")
                }
                .frame(width : 231, height : 36)
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // ntar ganti dengan fungsi searcy dari conversation contact list
                SearchBar(
                    text: $contactViewModel.searchText,
                    
                    onSearch : {
                        contactViewModel.searchConversations()
                    }
                )
                .frame(maxWidth : 382, alignment : .trailing)
            }
            .padding(.bottom, 16)
            
            ContactTableView(
                conversations: Conversation.humanDummyData + Conversation.aiDummyData,
                onContactSelected: { conversation in
                    print("Selected: \(conversation.name)")
                }
            )
        }
    }
}

#Preview {
    MainContactView(contactViewModel: ConversationListViewModel.shared, addContactAction : {})
        .padding()
}
