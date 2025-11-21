//
//  MainContactView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 18/11/25.
//

import SwiftUI

struct MainContactView: View {
    @StateObject private var contactViewModel = ContactViewModel()

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

                SearchBar(
                    text: $contactViewModel.searchText,
                    onSearch : {
                        contactViewModel.searchContacts()
                    }
                )
                .frame(maxWidth : 382, alignment : .trailing)
            }
            .padding(.bottom, 16)

            ContactTableView(
                contacts: contactViewModel.filteredContacts,
                onContactSelected: { contact in
                    contactViewModel.selectContact(contact)
                }
            )
        }
    }
}

#Preview {
    MainContactView(addContactAction : {})
        .padding()
}
