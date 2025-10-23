//
//  pending.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/10/25.
//

import SwiftUI

enum statusType{
    case pending
    case open
    case resolved
    
    var text: String {
        switch self {
        case .pending:
            return "Pending"
        case .open:
            return "Open"
        case .resolved:
            return "Resolved"
        }
    }
    
    var color : Color {
        switch self {
        case .pending:
            return Color.redStatusColor
        case .open:
            return Color.yellowStatusColor
        case .resolved:
            return Color.greenStatusColor
        }
    }
}


struct Status: View {
    let type : statusType
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(type.color)
                .frame(width: 53, height: 17)
                .cornerRadius(11)
            
            Text(type.text)
                .foregroundColor(.white)
                .font(.system(size: 11))
                .fontWeight(.regular)
                .padding(.horizontal, 7)
                .padding(.vertical, 2)

        }
    }
}

#Preview {
    VStack{
        Status(type : .pending)
        Status(type : .open)
        Status(type : .resolved)
    }
}
