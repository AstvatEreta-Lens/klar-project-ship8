//
//  HandledBySection.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 29/10/25.
//

import SwiftUI

struct HandledBySection: View { // bantu preview doang
//    @State private var conversation: Conversation
    
    let user: User
    let time: String
    let handlerType: HandlerType
    let status: statusType?
    let handledDate: Date
    
    var body: some View {
        HStack{
            UserAvatarView(name : user.name)
            VStack(alignment: .leading){
                Text(user.name)
                    .foregroundColor(Color.textRegular)
                    .font(.caption)
                
                HStack(spacing:1){
                    Text(handledDate.formattedShortDayDate())
                    .font(.caption)
                    .foregroundColor(Color.secondaryUsernameText)
                    
                    Text("·")
                        .baselineOffset(2)
                        .foregroundColor(Color.secondaryUsernameText)
                    
                    Text(time)
                    .font(.caption)
                    .foregroundColor(Color.secondaryUsernameText)
                }
            }
        }
    }
}

extension Date {
    func formattedShortDayDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy"
        return formatter.string(from: self)
    }
}


#Preview{
    HandledBySection(
        user: User(name: "Imron Mariadi", profileImage: "Pak Lu Hoot"),
        time: "14.29",
        handlerType: .human,
        status: nil,
        handledDate: Date().addingTimeInterval(-3600 * 4)
    )
    .padding()
    .background(Color.white)
}

