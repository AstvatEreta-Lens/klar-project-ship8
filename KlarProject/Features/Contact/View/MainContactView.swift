//
//  MainContactView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 18/11/25.
//

import SwiftUI

struct MainContactView: View {
    @StateObject private var contactViewModel = ContactViewModel()
    @State private var showAddContact: Bool = false

    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Contact")
                    .font(.largeTitle)
                    .foregroundColor(Color.sectionHeader)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                HStack(spacing: 12) {
                    Button(action: {
                        showAddContact = true
                    }){
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(Color.white)
                            Text("Add Contact")
                                .font(.title2)
                                .foregroundColor(Color.white)
                        }
                        .frame(minWidth: 231, maxWidth: .infinity, minHeight: 36, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 11)
                                .foregroundColor(Color.sectionHeader)
                                
                        )
                    }
                    .frame(width : 231,
                           height : 36)
                    .buttonStyle(PlainButtonStyle())

              
                    Spacer()

                    SearchBar(
                        text: $contactViewModel.searchText,
                        onSearch : {
                            contactViewModel.searchContacts()
                        }
                    )
                    .frame(maxWidth : 382, alignment : .trailing)
                    
//                    Image(systemName: "slider.horizontal.3")
//                        .font(.body)
//                        .foregroundColor(Color.primaryText)
                }
                .padding(.bottom, 16)

                ContactTableView(
                    contacts: contactViewModel.filteredContacts,
                    onContactSelected: { contact in
                        contactViewModel.selectContact(contact)
                    }
                )
            }
            .blur(radius: showAddContact ? 3 : 0)
            .disabled(showAddContact)
            
            // Overlay AddContactView
            if showAddContact {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showAddContact = false
                    }
                
                AddContactView(
                    onSave: { newContact in
                        contactViewModel.addContact(newContact)
                        showAddContact = false
                    },
                    onCancel: {
                        showAddContact = false
                    }
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showAddContact)
    }
}

#Preview {
    MainContactView()
        .padding()
}
