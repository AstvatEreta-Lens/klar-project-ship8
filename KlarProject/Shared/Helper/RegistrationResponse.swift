//
//  RegistrationResponse.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 06/11/25.
//

import Foundation
struct RegistrationResponse: Codable {
    let success: Bool
    let clientId: String?
    let message: String?
}
