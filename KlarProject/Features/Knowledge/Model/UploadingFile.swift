//
//  UploadingFile.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 18/11/25.
//


import SwiftUI
import Combine

struct UploadingFile: Identifiable {
    let id = UUID()
    let fileName: String
    let fileURL: URL
    var progress: Double = 0.0
    var isCompleted: Bool = false
}