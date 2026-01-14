//
//  CollaboratorsViewModel.swift
//  KlarProject
//
//  Created by Assistant on 04/11/25.
//
//
//import SwiftUI
//
//class CollaboratorsViewModel: ObservableObject {
//    @Published var conversation: Conversation
//    @Published var availableUsers: [User] = []
//    @Published var searchText: String = ""
//    
//    init(conversation: Conversation) {
//        self.conversation = conversation
//        loadAvailableUsers()
//    }
//    
//    var filteredUsers: [User] {
//        if searchText.isEmpty {
//            return availableUsers
//        }
//        return availableUsers.filter { user in
//            user.name.localizedCaseInsensitiveContains(searchText) ||
//            user.email.localizedCaseInsensitiveContains(searchText)
//        }
//    }
//    
//    func loadAvailableUsers() {
//        // Dummy data, ganti dengan API call nantinya
//        let allUsers = [
//            User(name: "Ahmad Rizki", profileImage: "Photo Profile", email: "ahmad.rizki@example.com"),
//            User(name: "Budi Santoso", profileImage: "Photo Profile", email: "budi.santoso@example.com"),
//            User(name: "Citra Dewi", profileImage: "Photo Profile", email: "citra.dewi@example.com"),
//            User(name: "Dewi Lestari", profileImage: "Photo Profile", email: "dewi.lestari@example.com"),
//            User(name: "Eko Prasetyo", profileImage: "Photo Profile", email: "eko.prasetyo@example.com"),
//            User(name: "Fitri Handayani", profileImage: "Photo Profile", email: "fitri.handayani@example.com"),
//            User(name: "Gunawan", profileImage: "Photo Profile", email: "gunawan@example.com"),
//            User(name: "Hendra Wijaya", profileImage: "Photo Profile", email: "hendra.wijaya@example.com"),
//            User(name: "Indah Permata", profileImage: "Photo Profile", email: "indah.permata@example.com"),
//            User(name: "Joko Widodo", profileImage: "Photo Profile", email: "joko.widodo@example.com")
//        ]
//        
//        // Filter user yang belum jadi collaborator
//        availableUsers = allUsers.filter { newUser in
//            !conversation.collaborators.contains(where: { $0.id == newUser.id })
//        }
//    }
//    
//    func addCollaborator(_ user: User) {
//        // Cek apakah user sudah ada
//        guard !conversation.collaborators.contains(where: { $0.id == user.id }) else {
//            return
//        }
//        
//        conversation.collaborators.append(user)
//        loadAvailableUsers()
//        
//        saveToBackend()
//    }
//    
//    func removeCollaborator(_ user: User) {
//        conversation.collaborators.removeAll(where: { $0.id == user.id })
//        loadAvailableUsers()
//        
//        saveToBackend()
//    }
//    
//    private func saveToBackend() {
//        print("Simpan collaborators...")
//        print("Current collaborators: \(conversation.collaborators.map { $0.name })")
//    }
//}
