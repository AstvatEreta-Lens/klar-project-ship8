//
//  HandledBySection.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 29/10/25.
//

import SwiftUI

struct HandledBySection: View { // bantu preview doang
    let user: User
    let time: String
    let handlerType: HandlerType
    let status: statusType?
    
    var body: some View {
        UserAvatarView(name : user.name)
    }
}

#Preview{
    HandledBySection(
        user: User(name: "Imron Mariadi", profileImage: "Pak Lu Hoot"),
        time: "14.29",
        handlerType: .human,
        status: nil
    )
    .padding()
    .background(Color.white)
}

