//
//  AddContactView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/11/25.
//

import SwiftUI

enum Channel: String, CaseIterable {
    case whatsapp = "WhatsApp"
    case web = "Website"
    case email = "Shopee"
    case tokopedia = "Tokopedia"
}

enum ContactTag: String, CaseIterable {
    case service = "Service"
    case warranty = "Warranty"
    case payment = "Payment"
    case maintenance = "Maintenance"
    case spareparts = "Spareparts"
}

struct AddContactView: View {
    @State private var contactName: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var selectedChannel: Channel = .whatsapp
    @State private var selectedTags: Set<ContactTag> = []
    
    var onSave: (ContactModel) -> Void
    var onCancel: () -> Void
    
    // Computed property untuk validasi form
    private var isFormValid: Bool {
        !contactName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty &&
        !address.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func toggleTag(_ tag: ContactTag) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    
    private func saveContact() {
        let newContact = ContactModel(
            name: contactName,
            channel: phoneNumber,
            address: address,
            tags: selectedTags.map { $0.rawValue }
        )
        onSave(newContact)
    }
    
    private func resetForm() {
        contactName = ""
        phoneNumber = ""
        address = ""
        selectedChannel = .whatsapp
        selectedTags.removeAll()
    }
    
    var body: some View {
        VStack{
            CustomSegmentPicker1(selectedTab: .constant(0))
                .frame(width : 296, height : 32)
                .padding(.top)
            
            VStack(alignment: .leading) {
                Text("Create a new Contact")
                    .foregroundColor(Color.textRegular)
                    .padding(.leading)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 12)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        ContactInput(label: "Name", text: $contactName)
                        ContactInput(label: "Phone Number", text: $phoneNumber)
                        ContactInput(label: "Address", text: $address)
                    }
                    .foregroundColor(Color.textRegular)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("Pick the channel")
                                .foregroundColor(Color.textRegular)
                                .font(.subheadline)
                            
                            Menu {
                                ForEach(Channel.allCases, id: \.self) { channel in
                                    Button(channel.rawValue) {
                                        selectedChannel = channel
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedChannel.rawValue)
                                        .foregroundColor(Color.textRegular)
                                }
                                .padding(8)
                                .background(Color.gray)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.bottom, 20)
                        
                        HStack(alignment : .top){
                            Text("Tags")
                                .foregroundColor(Color.textRegular)
                                .font(.subheadline)
                                .padding(.bottom, 5)
                            
                            VStack(spacing: 11) {
                                // Row 1: Service, Warranty, Payment
                                HStack(spacing: 11) {
                                    TagButton(
                                        tag: .service,
                                        isSelected: selectedTags.contains(.service),
                                        action: { toggleTag(.service) }
                                    )
                                    .padding(.leading, -50)
                                    
                                    TagButton(
                                        tag: .warranty,
                                        isSelected: selectedTags.contains(.warranty),
                                        action: { toggleTag(.warranty) }
                                    )
                                    
                                    TagButton(
                                        tag: .payment,
                                        isSelected: selectedTags.contains(.payment),
                                        action: { toggleTag(.payment) }
                                    )
                                }
                                
                                // Row 2: Maintenance, Spareparts
                                HStack(spacing: 11) {
                                    TagButton(
                                        tag: .maintenance,
                                        isSelected: selectedTags.contains(.maintenance),
                                        action: { toggleTag(.maintenance) }
                                    )
                                    
                                    TagButton(
                                        tag: .spareparts,
                                        isSelected: selectedTags.contains(.spareparts),
                                        action: { toggleTag(.spareparts) }
                                    )
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    .frame(width: 300)
                }
                .padding()
            }
            
            Button(action : {
                if isFormValid {
                    saveContact()
                    resetForm()
                }
            }){
                HStack{
                    Text("Continue")
                        .foregroundColor(Color.white)
                        .font(.body)
                        .fontWeight(.light)
                        .frame(minWidth : 656, maxWidth: .infinity, minHeight : 36, maxHeight: .infinity, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 11)
                                .foregroundColor(isFormValid ? Color.sectionHeader : Color.gray.opacity(0.5))
                                
                        )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            .buttonStyle(PlainButtonStyle())
            .disabled(!isFormValid)
        }
        .padding(.top)
        .frame(minWidth : 700, minHeight : 409)
        .background(Color.white)
        .cornerRadius(11)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.sectionHeader, style: StrokeStyle(lineWidth: 1))
            
        )
    }
}

struct ContactInput: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
            
            EditableTextBox(text : $text)
        }
        .padding(.bottom, 15)
    }
}

struct TagButton: View {
    let tag: ContactTag
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag.rawValue)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.sectionHeader : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview{
    AddContactView(
        onSave: { contact in
            print("Saved: \(contact.name)")
        },
        onCancel: {
            print("Cancelled")
        }
    )
    .padding(20)
}
