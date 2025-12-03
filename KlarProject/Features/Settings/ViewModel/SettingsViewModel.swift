//
//  SettingsViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 12/11/25.
//

// harusnya ga ribet soalnya ambil dari model, cuma nunjukin apa

import SwiftUI
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var userProfiles: [UserProfile] = UserProfile.dummyList // nanti ubah ke real data
    @Published var securityProperties: [SecurityProperties] = SecurityProperties.dummyList
    @Published var platformConfigs: WhatsAppConfig = .default
    
}
