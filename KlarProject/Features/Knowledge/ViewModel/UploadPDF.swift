//
//  UploadPDF.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 11/11/25.
//

import AppKit


func uploadKnowledgeBaseFile() -> URL? {
    let panel = NSOpenPanel()
    panel.allowedContentTypes = [.item]
    panel.canChooseFiles = true
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    panel.title = "Select a file to be uploaded in Knowledge Base"
    
    if panel.runModal() == .OK, let selectedURL = panel.url {
        let fileManager = FileManager.default
        let appSupportURL = try! fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("UploadedFiles", isDirectory: true)

        if !fileManager.fileExists(atPath: appSupportURL.path) {
            try? fileManager.createDirectory(at: appSupportURL, withIntermediateDirectories: true)
        }

        let destinationURL = appSupportURL.appendingPathComponent(selectedURL.lastPathComponent)

        // Copy file ke lokal
        if fileManager.fileExists(atPath: destinationURL.path) {
            try? fileManager.removeItem(at: destinationURL)
        }
        try? fileManager.copyItem(at: selectedURL, to: destinationURL)

        return destinationURL
    }
    
    return nil
}
