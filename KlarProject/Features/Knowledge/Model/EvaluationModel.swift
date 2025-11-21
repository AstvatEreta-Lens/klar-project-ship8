//
//  EvaluationModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 11/11/25.
//

import Foundation

struct EvaluationModel: Identifiable {
    let id : UUID
    let conversationID: UUID
    let name : String
    let time : String
    let date : Date
    let handledBy : User // Panggil dari ConversationModel
    
    init(
        id: UUID = UUID(),
        conversationID: UUID,
        name: String,
        time: String,
        date: Date,
        handledBy: User
    ) {
        self.id = id
        self.conversationID = conversationID
        self.name = name
        self.time = time
        self.date = date
        self.handledBy = handledBy
    }
}
