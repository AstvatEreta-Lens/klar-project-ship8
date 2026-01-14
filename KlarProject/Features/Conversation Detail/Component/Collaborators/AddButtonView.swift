//
//  AddButtonView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 03/11/25.
//
//
//import SwiftUI
//
//struct ContentHeightKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}
//
//struct AgentListView: View {
//    let users: [User]
//    let onUserSelected: (User) -> Void
//    @State private var contentHeight: CGFloat = 0
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 8) {
//                ForEach(users) { user in
//                    AgentRow(agent: user, onTap: {
//                        onUserSelected(user)
//                    })
//                }
//            }
//            .padding(.vertical, 8)
//            .background(
//                GeometryReader { geo in
//                    Color.clear
//                        .preference(key: ContentHeightKey.self, value: geo.size.height)
//                }
//            )
//        }
//        .frame(height: min(contentHeight, 300))
//        // Ubah tinggi frame setiap berubah
//        .onPreferenceChange(ContentHeightKey.self) { height in
//            contentHeight = height
//        }
//    }
//}
//
//struct AgentRow: View {
//    let agent: User
//    let onTap: () -> Void
//    
//    var body: some View {
//        Button(action: onTap) {
//            HStack(spacing: 12) {
//                // Avatar
//                UserAvatarView(name: agent.name)
//                
//                VStack(alignment: .leading, spacing: 2) {
//                    Text(agent.name)
//                        .font(.subheadline)
//                        .fontWeight(.medium)
//                        .foregroundColor(Color.primary)
//                    
//                    Text(agent.email)
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding(.horizontal, 12)
//            .padding(.vertical, 8)
//            .contentShape(Rectangle())
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//struct AddCollaboratorView: View {
//    @ObservedObject var viewModel: CollaboratorsViewModel
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Add a collaborator")
//                .font(.caption)
//                .fontWeight(.semibold)
//
//            SearchBar(text: $viewModel.searchText)
//            
//            // User List
//            if viewModel.filteredUsers.isEmpty {
//                VStack(spacing: 12) {
//                    Image(systemName: "person.slash")
//                        .font(.system(size: 32))
//                        .foregroundColor(.gray)
//                    
//                    Text("No users found")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                .frame(maxWidth: .infinity)
//                .frame(height: 100)
//            } else {
//                AgentListView(
//                    users: viewModel.filteredUsers,
//                    onUserSelected: { user in
//                        viewModel.addCollaborator(user)
//                        dismiss()
//                    }
//                )
//            }
//
//            Button(action: {
//                print("Create new agent tapped")
//            }) {
//                ZStack {
//                    Rectangle()
//                        .cornerRadius(11)
//                        .frame(width: 149, height: 24)
//                        .foregroundColor(Color.backgroundPrimary)
//                        .cornerRadius(11)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 11)
//                                .stroke(Color.secondaryText, lineWidth: 1)
//                        )
//                    HStack {
//                        Image(systemName: "tag.fill")
//                            .font(.caption)
//                        Text("Create a new agent")
//                            .font(.caption)
//                            .fontWeight(.bold)
//                    }
//                    .foregroundColor(Color.secondaryText)
//                    .bold()
//                }
//                .padding(.leading)
//            }
//            .buttonStyle(PlainButtonStyle())
//        }
//        .padding()
//        .frame(width: 218)
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.white)
//        )
//    }
//}
//
//// MARK: - Preview
//
//#Preview("Empty State") {
//    @Previewable var viewModel = CollaboratorsViewModel(
//        conversation: Conversation.humanDummyData[1]
//    )
//    
//    return AddCollaboratorView(viewModel: viewModel)
//        .frame(width: 290)
//}
//
//#Preview("With Users") {
//    @Previewable var viewModel = CollaboratorsViewModel(
//        conversation: Conversation.humanDummyData[0]
//    )
//    
//    return AddCollaboratorView(viewModel: viewModel)
//        .frame(width: 290)
//}
