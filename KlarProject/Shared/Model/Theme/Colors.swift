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
    // Primary Text Color
    static let primaryTextColor = Color("PrimaryTextColor")
    
    // Secondary Text Color
    static let secondaryTextColor = Color("SecondaryTextColor")
    
    // Tertiary Text Color
    static let tertiaryTextColor = Color("TertiaryTextColor")
    
    // Border Color
    static let borderColor = Color("BorderColor")
    
    
    // Red Status Color
    static let redStatusColor = Color("RedStatus")
    
    // Yellow Status Color
    static let yellowStatusColor = Color("YellowStatus")
    
    // Resolved Status Color
    static let greenStatusColor = Color("GreenStatus")
    
    // Status Text Color
    static let greenStatusTextColor = Color("GreenStatusTextColor")
    static let yellowStatusTextColor = Color("YellowStatusTextColor")
    static let redStatusTextColor = Color("RedStatusTextColor")
    
    // Background Primary
    static let bakcgroundPrimary = Color("BackgroundPrimary")
    
    // Label border Color
    static let labelBorderColor = Color("LabelBorderColor")
    
    // Label Text Color
    static let labelTextColor = Color("LabelTextColor")
    
    // Avatar Background Color
    static let avatarBackgroundColor = Color("AvatarColor")
    
    // Avatar Count Color
    static let avatarCountColor = Color("AvatarCountColor")
    
    // Chat Box Button Color
    static let chatboxButtonColor = Color("ChatTextboxButton")
    
    // Bubble Chat Color
    static let bubbleChatColor = Color("BubbleChatColor")
    
    static let textRegularColor = Color("TextRegular")
    
    static let chatInputBackgroundColor = Color("ChatInputBackground")
    
    // Evaluated Background
    static let evaluatedBackgroundCard = Color("BackgroundTertiary")
    
    // Unable to Evaluate Background
    static let unableToEvaluateBackgroundCard = Color("UnableToEvaluateColor")
    
    static let colorBlackText = Color("PureBlack")
    
    static let sectionHeaderColor = Color("SectionHeaderColor")
    
    
    // Grey Color
    static let greySecondary = Color(hex: "#545454")
    
    // Black Secondary
    static let blackSecondary = Color(hex: "#3E3E3E")
    
    // Divider Color
    static let dividerColor = Color(hex: "#969696")
    
    // Grey Text Color
    static let grayTextColor = Color(hex:"#8E8E8E")
    
    
    
    
    
    
    
    
    
    // Choosen Color
    static let chosenColor = Color(hex:"#C0E3FF")
    
    // Chat Chosen Color
    static let chatChosenColor = Color(hex:"#EDEDED")
    
    // Black Label
    static let blackLabel = Color(hex:"#000000")
    
    // Bold gray text
    static let boldGrayText = Color(hex:"#505050")
    
    // Blue Text Color
    static let blueTextColor = Color(hex: "#0091FF")
    
    // Detail Component Color
    static let componentBackgroundColor = Color(hex :"#F5F5F5")
    
    // Component Component Color
    static let componentComponentColor = Color(hex: "#B9B9B9")

}


