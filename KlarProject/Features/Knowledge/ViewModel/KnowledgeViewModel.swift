//
//  KnowledgeViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//


import SwiftUI
import Combine

@MainActor
class KnowledgeViewModel: ObservableObject {
    
    @Published var conversations: [Conversation] = []
    @Published var searchText: String = ""
    @Published var files: [PDFDocument] = []
    @Published var selectedPDF: PDFDocument?
    
    init() {
        loadExistingFiles()
    }
    
    func searchFile() {
        // Implement search functionality
    }
    
    var uploadedFiles: Int {
        return files.count
    }
    
    func selectPDF(_ pdf: PDFDocument) {
        selectedPDF = pdf
    }
    
    func uploadPDF() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.pdf]
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.title = "Select a PDF file to be uploaded to Knowledge Base"

        if panel.runModal() == .OK, let url = panel.url {
            savePDFToLocal(url: url)
        }
    }
    
    private func savePDFToLocal(url: URL) {
        do {
            let fileManager = FileManager.default
            let destinationDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent("KlarApp/PDFs", isDirectory: true)
            
            try fileManager.createDirectory(at: destinationDir, withIntermediateDirectories: true)

            let fileName = url.lastPathComponent
            let destinationURL = destinationDir.appendingPathComponent(fileName)
            
            // Remove existing file if present
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            
            try fileManager.copyItem(at: url, to: destinationURL)

            let newFile = PDFDocument(title: fileName.replacingOccurrences(of: ".pdf", with: ""), fileURL: destinationURL)
            files.append(newFile)
            
            print("PDF saved successfully: \(fileName)")
        } catch {
            print("Failed to save file: \(error)")
        }
    }
    
    private func loadExistingFiles() {
        do {
            let fileManager = FileManager.default
            let destinationDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent("KlarApp/PDFs", isDirectory: true)
            
            if fileManager.fileExists(atPath: destinationDir.path) {
                let fileURLs = try fileManager.contentsOfDirectory(at: destinationDir, includingPropertiesForKeys: nil)
                
                for fileURL in fileURLs where fileURL.pathExtension == "pdf" {
                    let title = fileURL.deletingPathExtension().lastPathComponent
                    let pdfDoc = PDFDocument(title: title, fileURL: fileURL)
                    files.append(pdfDoc)
                }
                
                print("Loaded \(files.count) existing PDF(s)")
            }
        } catch {
            print("Failed to load existing files: \(error)")
        }
    }
}
