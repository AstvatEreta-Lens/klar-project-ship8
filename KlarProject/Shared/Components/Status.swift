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
    
    var colorText : Color{
        switch self {
        case .pending:
            return Color.redStatusTextColor
        case .open:
            return Color.yellowStatusTextColor
        case .resolved:
            return Color.greenStatusTextColor
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
                .foregroundColor(type.colorText)
                .font(.caption)
                .fontWeight(.light)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)

        }
        .padding(.trailing, 7)
    }
}

#Preview {
    VStack{
        Status(type : .pending)
        Status(type : .open)
        Status(type : .resolved)
    }
    .padding(10)
}
