//
//  ContactModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/11/25.
//

import Foundation

struct ContactModel: Identifiable{
    let id : UUID
    let name :  String
    let channel : String
    let address :  String
    let tags : [String]
    
    init(
        id: UUID = UUID(),
        name: String,
        channel : String,
        address :  String,
        tags : [String]
    ){
        self.id = id
        self.name = name
        self.channel = channel
        self.address = address
        self.tags = tags
    }
}

extension ContactModel{
    static let contactModelDummydata : [ContactModel] = [
        ContactModel(name: "John", channel: "08123456789", address: "Jalan Jati", tags: ["Servis"]),
        ContactModel(name: "Jane", channel: "08123456789", address: "Jalan Jati", tags: ["Warranty", "Maintenance"]),
        ContactModel(name: "Bob", channel: "08123456789", address: "Jalan Jati", tags: ["Friend", "Colleague", "Family"]),
        ContactModel(name: "Imron", channel: "08123456789", address: "Jalan Jati", tags: ["Friend", "Colleague", "Family"]),
        ContactModel(name: "Don Corleone", channel: "08123456789", address: "Jalan Jati", tags: ["Friend", "Colleague", "Family"]),
        ContactModel(name: "Keanu Reeves", channel: "08123456789", address: "Jalan Jati", tags: ["Friend", "Colleague", "Family"]),
        ContactModel(name: "Kapten Amrik", channel: "08123456789", address: "Jalan Jati", tags: ["Friend", "Colleague", "Family"]),
        ]
}
