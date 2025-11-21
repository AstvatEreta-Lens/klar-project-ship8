//
//  dump.swift
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
    case sparepart = "Sparepart"
    case payment = "Payment"
}

struct TagButton: View {
    let tag: ContactTag
    @Binding var isSelected: Bool
    
    var body: some View {
        Text(tag.rawValue)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(isSelected ? Color.blue : Color.gray)
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .onTapGesture {
                isSelected.toggle()
            }
    }
}
struct AddContactView: View {
    @State private var contactName: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var selectedChannel: Channel = .whatsapp
    @State private var selectedTags: Set<ContactTag> = []
    
    var body: some View {
        // --- Header ---
        VStack{
            Text("Create a new Contact")
                .font(.headline)
                .bold()
                .padding(.top, 12)
                Spacer()

            VStack(alignment: .leading) {
                // --- Dua Kolom Utama (Input Kiri dan Picker/Tags Kanan) ---
                HStack(alignment: .top) {
                    // Kolom Kiri: Name, Phone, Address
                    VStack(alignment: .leading) {
                        ContactInput(label: "Name", text: $contactName)
                        ContactInput(label: "Phone Number", text: $phoneNumber)
                        ContactInput(label: "Address", text: $address)
                    }
                    
                    // Spacer untuk memisahkan Kolom Kiri dan Kanan
                    Spacer()
                    
                    // Kolom Kanan: Picker dan Tags
                    VStack(alignment: .leading) {
                        
                        // --- Channel Picker ---
                        HStack {
                            Text("Pick the channel")
                                .font(.subheadline)
                            
                            // Menu/Picker Sesuai Gambar
                            Menu {
                                ForEach(Channel.allCases, id: \.self) { channel in
                                    Button(channel.rawValue) {
                                        selectedChannel = channel
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedChannel.rawValue)
                                }
                                .padding(8)
                                .background(Color.gray)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // --- Tags Section ---
                        Text("Label")
                            .font(.subheadline)
                            .padding(.bottom, 5)
                        
                        // Implementasi Tags (menggunakan Flow Layout sederhana)
                        HStack {
                            ForEach(ContactTag.allCases, id: \.self) { tag in
                                TagButton(tag: tag, isSelected: .constant(selectedTags.contains(tag)))
                                    .onTapGesture {
                                        if selectedTags.contains(tag) {
                                            selectedTags.remove(tag)
                                        } else {
                                            selectedTags.insert(tag)
                                        }
                                    }
                            }
                        }
                        
                        // --- Create New Label ---
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Label")
                                    .font(.caption)
                                    .foregroundColor(Color.textRegular)
                                
//                                if !conversation.label.isEmpty {
//                                    VStack(alignment: .leading, spacing: 8) {
//                                        ForEach(conversation.label.chunked(into: 3), id: \.first!.text) { chunk in
//                                            HStack(spacing: 8) {
//                                                ForEach(chunk, id: \.text) { label in
//                                                    LabelView(label: label) {
//                                                        detailViewModel.deleteLabel(label)
//                                                    }
//                                                }
//                                                Spacer()
//                                            }
//                                        }
//                                    }
//                                } else {
//                                    Text("No labels added")
//                                        .font(.caption)
//                                        .foregroundColor(Color.primaryUsernameText)
//                                }
                            }
                            .padding(.leading, 20)
                            
                            Spacer()
                            
                            AddButton(addLabelImage: "tag.fill") {
                                detailViewModel.showingAddLabel.toggle()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 62, height: 24)
                            .padding(.trailing, 14)
                        }
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                        
                        //Spacer()
                    }
                    .frame(width: 300) // Atur lebar kolom kanan
                }
                .padding()
                Spacer()
                
                // Spacer di antara konten dan tombol Continue
                //Spacer()
                
                ContactContinueButton(contactContinueAction: {})
                    .frame(height: 36)
                    .padding(.horizontal)
                    .padding(.bottom, 28)
                    
            }
            .padding(.top)
            
        }
        .frame(width : 700, height : 409)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
            .stroke(Color.sectionHeader, style: StrokeStyle(lineWidth: 1))
                
            )
    }
}

// --- Komponen Pembantu untuk Input Teks ---
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

#Preview {
    AddContactView()
        .padding(20)
}
