//
//  CardStateColor.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 13/11/25.
//

import SwiftUI

enum CardStateColor{
    case selected
    case unevaluated
    case evaluated
    
    var basicColor : Color {
        switch self{
        case.selected :
            return Color.bubbleChat
            
        case.unevaluated :
            return Color.labelText
            
        case.evaluated :
            return Color.evaluatedBackgroundCard
        }
    }
    
    var textColor : Color {
        switch self {
        case.selected :
            return Color.textRegular
        case.unevaluated :
            return Color.textRegular
        case.evaluated :
            return Color.avatarCount
        }
    }
}
