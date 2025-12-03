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
    var imageProfile : String
    
    init(id: UUID = UUID(), username: String, phoneNumber: String, imageProfile : String) {
            self.id = id
            self.username = username
            self.phoneNumber = phoneNumber
            self.imageProfile = imageProfile
        }
    
    
    // Dummy
    static let dummyList: [UserProfile] = [
        UserProfile(username: "NicholasTristandiii", phoneNumber: "+628123456789", imageProfile : "Pak Lu Hoot"),
        UserProfile(username: "AhmadRifqi", phoneNumber: "+628987654321", imageProfile : "Pak Lu Hoot"),
        UserProfile(username: "ClaraWijaya", phoneNumber: "+628555443322", imageProfile : "Pak Lu Hoot")
    ]
}

struct SecurityProperties: Identifiable, Codable {
    let id : UUID
    var workSpaceEmail : String
    var role : String
    var password: String
    var PIN : String
    
    init(id : UUID = UUID(), workSpaceEmail : String, role : String, password: String, PIN : String){
        self.id = id
        self.workSpaceEmail = workSpaceEmail
        self.role = role
        self.password = password
        self.PIN = PIN
    }
    
    // Dummy
    static let dummyList: [SecurityProperties] = [
        SecurityProperties(workSpaceEmail: "nicolas.tristandi@gmail.com", role: "Owner", password: "123456", PIN: "1234"),
        SecurityProperties(workSpaceEmail: "ahmad.rifqi@gmail.com", role: "Owner", password: "123456", PIN: "1234")
        ]
}

