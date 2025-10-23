//
//  Colors.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    // Grey Color
    static let greySecondary = Color(hex: "#545454")
    
    // Black Secondary
    static let blackSecondary = Color(hex: "#3E3E3E")
    
    // Divider Color
    static let dividerColor = Color(hex: "#969696")
    
    // Grey Text Color
    static let grayTextColor = Color(hex:"#8E8E8E")
    
    // Red Status Color
    static let redStatusColor = Color(hex:"EB0000")
    
    // Yellow Status Color
    static let yellowStatusColor = Color(hex:"FFA600")
    
    // Resolved Status Color
    static let greenStatusColor = Color(hex:"16A600")
    
    // Choiced Color
    static let chosenColor = Color(hex:"#C0E3FF")
    
    // Chat Chosen Color
    static let chatChosenColor = Color(hex:"#EDEDED")

}


