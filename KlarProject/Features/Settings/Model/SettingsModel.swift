//
//  SettingsModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 12/11/25.
//

// Modelnya harusnya ambil dari conversation?? atau tanya al model buat user gmn

// Model sementara

import Foundation

struct UserProfile : Identifiable, Codable{
    let id : UUID
    var username: String
    var phoneNumber: String
    
    init(id: UUID = UUID(), username: String, phoneNumber: String) {
            self.id = id
            self.username = username
            self.phoneNumber = phoneNumber
        }
    
    
    // Dummy
    static let dummyList: [UserProfile] = [
        UserProfile(username: "NicholasTristandi", phoneNumber: "+628123456789"),
        UserProfile(username: "AhmadRifqi", phoneNumber: "+628987654321"),
        UserProfile(username: "ClaraWijaya", phoneNumber: "+628555443322")
    ]
}
