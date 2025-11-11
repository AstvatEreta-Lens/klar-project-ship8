//
//  MainChatModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var uploadStatus: String = "No file uploaded yet"
    @Published var selectedFileURL: URL?
    
    func uploadFile(_ url: URL) {
        selectedFileURL = url
        uploadStatus = "Uploading \(url.lastPathComponent)..."
        
        // simulasi upload ke server
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.uploadStatus = "✅ Uploaded: \(url.lastPathComponent)"
        }
    }
}
