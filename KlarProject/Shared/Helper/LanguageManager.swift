//
//  LanguageManager.swift
//  KlarProject
//
//  Created by Claude Code on 29/11/25.
//

import SwiftUI
import Foundation

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.code, forKey: "selectedLanguage")
            setAppLanguage(currentLanguage.code)
            // Force UI refresh by updating locale
            locale = Locale(identifier: currentLanguage.code)
        }
    }

    @Published var locale: Locale

    private init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "id"
        self.currentLanguage = Language(rawValue: savedLanguage) ?? .id
        self.locale = Locale(identifier: savedLanguage)
        setAppLanguage(savedLanguage)
    }

    private func setAppLanguage(_ languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}

enum Language: String, CaseIterable, Identifiable {
    case en = "en"
    case id = "id"

    var id: String { self.rawValue }

    var code: String {
        self.rawValue
    }

    var displayName: String {
        switch self {
        case .en:
            return "English"
        case .id:
            return "Bahasa Indonesia"
        }
    }
}
