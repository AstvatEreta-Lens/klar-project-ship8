//
//  String+Extensions.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 01/11/25.
//

import Foundation

extension String {
    var initials: String {
        let words = self.components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        
        if words.isEmpty {
            return "?"
        }
        
        if words.count == 1 {
            let firstWord = words[0]
            if firstWord.count >= 2 {
                return String(firstWord.prefix(2)).uppercased()
            } else {
                return firstWord.uppercased()
            }
        }
        
        let firstInitial = words.first?.first ?? "?"
        let lastInitial = words.last?.first ?? "?"
        
        return "\(firstInitial)\(lastInitial)".uppercased()
    }
}
