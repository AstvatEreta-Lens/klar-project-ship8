//
//  ContactViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/11/25.
//

import SwiftUI
import Combine

@MainActor
class ContactViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var contacts: [ContactModel] = []
    @Published var selectedContact: ContactModel?
    @Published var searchText: String = ""

    // MARK: - Computed Properties

    // Filtered contacts based on search text
    var filteredContacts: [ContactModel] {
        if searchText.isEmpty {
            return contacts
        }

        return contacts.filter { contact in
            contact.name.localizedCaseInsensitiveContains(searchText) ||
            contact.channel.localizedCaseInsensitiveContains(searchText) ||
            contact.address.localizedCaseInsensitiveContains(searchText) ||
            contact.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
        }
    }

    init() {
        loadContacts()
    }


    func loadContacts() {
        contacts = ContactModel.contactModelDummydata
        print("Loaded \(contacts.count) contacts")
    }


    func searchContacts() {
        print("Searching contacts with: '\(searchText)'")
        print("Found \(filteredContacts.count) results")
    }

    func selectContact(_ contact: ContactModel) {
        selectedContact = contact
        print("Selected contact: \(contact.name)")
    }


    func addContact(_ contact: ContactModel) {
        contacts.append(contact)
        print("Added contact: \(contact.name)")
    }

    func updateContact(_ contact: ContactModel) {
        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts[index] = contact
            print("Updated contact: \(contact.name)")
        }
    }

    func deleteContact(_ contact: ContactModel) {
        contacts.removeAll { $0.id == contact.id }
        print("Deleted contact: \(contact.name)")
    }
}
