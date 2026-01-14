//
//  SettingsViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 12/11/25.
//

// harusnya ga ribet soalnya ambil dari model, cuma nunjukin apa

import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var userProfiles: [UserProfile] = UserProfile.dummyList // nanti ubah ke real data
    
    
}
