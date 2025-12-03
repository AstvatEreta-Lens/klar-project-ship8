//
//  ContactView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 17/11/25.
//

import SwiftUI

struct ContactTableView: View {

    let contacts: [ContactModel]
    @State private var selectedContact: ContactModel?

    // Callback untuk handle selection
    var onContactSelected: ((ContactModel) -> Void)?

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                headerRow(width: geometry.size.width)

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(contacts.enumerated()), id: \.element.id) { index, contact in
                            ContactRow(
                                number: index + 1,
                                contact: contact,
                                isSelected: selectedContact?.id == contact.id,
                                totalWidth: geometry.size.width
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedContact = contact
                                onContactSelected?(contact)
                            }
                        }
                    }
                }
                .frame(minHeight: 100)

                Text(NSLocalizedString("Total Data: ", comment : "") + " \(contacts.count)")
                    .font(.title3)
                    .foregroundColor(Color.textRegular)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .padding(.horizontal, 2)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.backgroundPrimary)
//                    .stroke(Color.gray.opacity(0.2), lineWidth: 0.2)
                    .shadow(color : .black.opacity(0.2), radius: 12, x: 6, y: 6)
            )
        }
    }

    func headerRow(width: CGFloat) -> some View {
        HStack(spacing: 0) {
            HStack {
                Spacer()
                headerText("No.")
                Spacer()
            }
            .frame(width: width * 0.05) // 5%

            HStack {
                Spacer()
                headerText("Name")
                Spacer()
            }
            .frame(width: width * 0.15) // 15%

            HStack {
                Spacer()
                headerText("Phone Number")
                Spacer()
            }
            .frame(width: width * 0.18) // 18%

            HStack {
                Spacer()
                headerText("Channel")
                Spacer()
            }
            .frame(width: width * 0.15) // 15%

            HStack {
                Spacer()
                headerText("Address")
                Spacer()
            }
            .frame(width: width * 0.32) // 32%

            HStack {
                Spacer()
                headerText("Tags")
                Spacer()
            }
            .frame(width: width * 0.15) // 15%
        }
        .padding(.vertical, 11)
        .background(
            RoundedRectangle(cornerRadius: 21)
                .fill(Color.backgroundTertiary)
        )
    }

    func headerText(_ text: String) -> some View {
        Text(text)
            .font(.title3)
            .foregroundColor(Color(hex : "#808080"))
    }
}

struct ContactRow: View {
    let number: Int
    let contact: ContactModel
    let isSelected: Bool
    let totalWidth: CGFloat

    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Spacer()
                Text("\(number)")
                    .foregroundColor(Color.textRegular)
                Spacer()
            }
            .frame(width: totalWidth * 0.05) // 5%

            HStack {
                Spacer()
                Text(contact.name)
                    .foregroundColor(Color.textRegular)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(width: totalWidth * 0.15) // 15%

            HStack {
                Spacer()
                Text(contact.channel)
                    .foregroundColor(Color.textRegular)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(width: totalWidth * 0.18) // 18%

            HStack {
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "message.circle.fill")
                        .foregroundColor(.green)
                    Text("WhatsApp")
                        .foregroundColor(Color.textRegular)
                }
                Spacer()
            }
            .frame(width: totalWidth * 0.15) // 15%

            HStack {
                Spacer()
                Text(contact.address)
                    .foregroundColor(Color.textRegular)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(width: totalWidth * 0.32) // 32%

            HStack {
                Spacer()
                Text(tagsText)
                    .foregroundColor(Color.textRegular)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(width: totalWidth * 0.15) // 15%
        }
        .padding(.vertical, 8)
        .background(isSelected ? Color.gray.opacity(0.5) : Color.backgroundPrimary)
        .overlay(
            Rectangle()
                .stroke(isSelected ? Color(hex : "F5F5F5"): Color.clear, lineWidth: 1)
        )
    }

    // Helper computed properties
    private var tagsText: String {
        if contact.tags.isEmpty {
            return "-"
        }
        return contact.tags.joined(separator: ", ")
    }
}

#Preview {
    // Preview dengan dummy data dari ContactModel
    ContactTableView(
        contacts: ContactModel.contactModelDummydata,
        onContactSelected: { contact in
            print("Selected: \(contact.name)")
        }
    )
    .frame(width : 1000, height: 400)
    .padding()
}
