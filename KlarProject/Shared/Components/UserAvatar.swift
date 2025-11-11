//
//  UserAvatarView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 01/11/25.
//

import SwiftUI

struct UserAvatarView: View {
    let name: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.avatarBackgroundColor)
            
            Text(name.initials)
                .font(.system(size : 12))
                .foregroundColor(.white)
        }
        .frame(width: 30, height: 30)
    }
}

struct avatarViewMore: View {
    let count : Int
    
    var body : some View {
        ZStack {
            Circle()
                .fill(Color.avatarCountColor)
            
            Text("+\(count)")
                .font(.system(size : 12))
                .foregroundColor(Color.white)
        }
        .frame(width: 30, height: 30)
    }
}

#Preview {
    HStack(spacing: 16) {
        UserAvatarView(name: "Supriyadi Yanto")
        UserAvatarView(name: "Putri Nabila Kusuma")
        UserAvatarView(name: "Ahmad Al Wabil")
        UserAvatarView(name: "Imron Mariadi")
        UserAvatarView(name : "Heru Supratman Kusuma")
        avatarViewMore(count : 3)
    }
    .padding()
}
