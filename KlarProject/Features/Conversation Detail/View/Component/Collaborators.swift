//
//  CollaboratorsSection.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 29/10/25.
//

import SwiftUI

struct CollaboratorsSection: View {
    let collaborators: [User]
    let onAddCollaborator: () -> Void
    
    private let maxDisplayed = 2
    
    var remainingCount: Int {
        max(0, collaborators.count - maxDisplayed)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                HStack(spacing: -4) {
                    ForEach(collaborators.prefix(maxDisplayed)) { user in
                        UserAvatarView(name : user.name)
                    }
                    
                    if collaborators.count > maxDisplayed {
                        avatarViewMore(count: remainingCount)
                    }
                    
                    // Add button
                    Button(action: onAddCollaborator) {
                        AddButton(addLabelImage: "person.fill.badge.plus") {
                            print("Person Badge Button Clicked")
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 12)
                }
            }
        }
    }
}

#Preview("Empty State") {
    CollaboratorsSection(
        collaborators: [],
        onAddCollaborator: {
            print("Add collaborator tapped")
        }
    )
    .frame(width: 290)
    .background(Color.white)
}

#Preview("Single Collaborator") {
    CollaboratorsSection(
        collaborators: [
            User(name: "Ninda", profileImage: "Pak Lu Hoot")
        ],
        onAddCollaborator: {
            print("Add collaborator tapped")
        }
    )
    .frame(width: 290)
    .background(Color.white)
}

#Preview("Two Collaborators") {
    CollaboratorsSection(
        collaborators: [
            User(name: "Ninda", profileImage: "Pak Lu Hoot"),
            User(name: "John", profileImage: "Pak Lu Hoot")
        ],
        onAddCollaborator: {
            print("Add collaborator tapped")
        }
    )
    .frame(width: 290)
    .background(Color.white)
}

#Preview("Three Collaborators") {
    CollaboratorsSection(
        collaborators: [
            User(name: "Ninda", profileImage: "Pak Lu Hoot"),
            User(name: "John", profileImage: "Pak Lu Hoot"),
            User(name: "Sarah", profileImage: "Pak Lu Hoot")
        ],
        onAddCollaborator: {
            print("Add collaborator tapped")
        }
    )
    .frame(width: 290)
    .background(Color.white)
}

#Preview("More Than Three") {
    CollaboratorsSection(
        collaborators: [
            User(name: "Ninda", profileImage: "Pak Lu Hoot"),
            User(name: "John", profileImage: "Pak Lu Hoot"),
            User(name: "Sarah", profileImage: "Pak Lu Hoot"),
            User(name: "Michael", profileImage: "Pak Lu Hoot"),
            User(name: "Emma", profileImage: "Pak Lu Hoot")
        ],
        onAddCollaborator: {
            print("Add collaborator tapped")
        }
    )
    .frame(width: 290)
    .background(Color.white)
}
