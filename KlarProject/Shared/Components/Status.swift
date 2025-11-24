//
//  pending.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/10/25.
//

import SwiftUI
import Foundation

enum statusType : Hashable{
    case pending
    case open
    case resolved
    
    var text: String {
        switch self {
        case .pending:
            return NSLocalizedString("Pending", comment :"")
        case .open:
            return NSLocalizedString("Open", comment :"")
        case .resolved:
            return NSLocalizedString("Resolved", comment :"")
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
                .frame(width: 62, height: 24)
                .cornerRadius(11)
            
            Text(type.text)
                .foregroundColor(type.colorText)
                .font(.caption)
                .fontWeight(.light)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)

        }
    }
}

extension statusType: CaseIterable {
    static var allCases: [statusType] = [.pending, .open, .resolved]
}

#Preview {
    VStack{
        Status(type : .pending)
        Status(type : .open)
        Status(type : .resolved)
    }
    .padding(10)
}
