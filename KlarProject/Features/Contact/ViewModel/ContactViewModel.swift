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

    @Published var contacts: [ContactModel] = []
    @Published var selectedContact: ContactModel?
    @Published var searchText: String = ""

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
    }

    func searchContacts() {
        print("Found \(filteredContacts.count)")
    }

    func selectContact(_ contact: ContactModel) {
        selectedContact = contact
    }

    func addContact(_ contact: ContactModel) {
        contacts.insert(contact, at: 0)
        print("Tambah: \(contact.name)")
    }

    func updateContact(_ contact: ContactModel) {
        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts[index] = contact
        }
    }

    func deleteContact(_ contact: ContactModel) {
        contacts.removeAll { $0.id == contact.id }
    }
}
