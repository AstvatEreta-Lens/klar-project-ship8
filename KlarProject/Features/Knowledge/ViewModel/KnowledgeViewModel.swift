//
//  KnowledgeViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
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

@MainActor
class KnowledgeViewModel: ObservableObject {
    
    @Published var conversations: [Conversation] = []
    @Published var searchText: String = ""
    @Published var files: [PDFDocument] = []
    @Published var selectedPDF: PDFDocument?
    @Published var uploadingFiles: [UploadingFile] = []
    @Published var selectedFiles: [URL] = []
    @Published var pdfToDelete: PDFDocument? = nil
    @Published var showDeleteAlert: Bool = false

    // Temporary storage for completed uploads
    private var completedUploads: [URL] = []

    // Filtered files based on search text
    var filteredFiles: [PDFDocument] {
        if searchText.isEmpty {
            return files
        }

        return files.filter { file in
            file.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    init() {
        loadExistingFiles()
    }

    func searchFile() {
        print("Searching for: \(searchText), Found \(filteredFiles.count) file(s)")
    }
    
    var uploadedFiles: Int {
        return files.count
    }
    
    func selectPDF(_ pdf: PDFDocument) {
        selectedPDF = pdf
    }
    
    // MARK: - Delete PDF Functions
    
    func requestDeletePDF(_ pdf: PDFDocument) {
        pdfToDelete = pdf
        showDeleteAlert = true
    }
    
    func confirmDeletePDF() {
        guard let pdf = pdfToDelete else { return }
        
        do {
            let fileManager = FileManager.default
            
            // Delete file from disk
            if fileManager.fileExists(atPath: pdf.fileURL.path) {
                try fileManager.removeItem(at: pdf.fileURL)
                print("PDF file deleted from disk: \(pdf.title)")
            }
            
            // Remove from array
            files.removeAll { $0.id == pdf.id }
            
            // Clear selection if deleted PDF was selected
            if selectedPDF?.id == pdf.id {
                selectedPDF = nil
            }
            
            print("PDF removed from list: \(pdf.title)")
        } catch {
            print("Failed to delete PDF: \(error)")
        }
        
        // Reset state
        pdfToDelete = nil
        showDeleteAlert = false
    }
    
    func cancelDeletePDF() {
        pdfToDelete = nil
        showDeleteAlert = false
    }
    
    // MARK: - Upload Functions
    
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
    
    // add files view
    
    func openFilePicker() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.pdf]
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.title = "Select PDF files to upload"

        if panel.runModal() == .OK {
            selectedFiles = panel.urls
            startUploadingFiles(urls: panel.urls)
        }
    }
    
    func handleDroppedFiles(providers: [NSItemProvider]) {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                DispatchQueue.main.async {
                    if let urlData = urlData as? Data,
                       let url = URL(dataRepresentation: urlData, relativeTo: nil),
                       url.pathExtension.lowercased() == "pdf" {
                        self.selectedFiles.append(url)
                        self.startUploadingFiles(urls: [url])
                    }
                }
            }
        }
    }
    
    func removeUploadingFile(_ id: UUID) {
        if let index = uploadingFiles.firstIndex(where: { $0.id == id }) {
            let url = uploadingFiles[index].fileURL
            uploadingFiles.remove(at: index)
            
            // Also remove from completed uploads if exists
            completedUploads.removeAll(where: { $0 == url })
        }
    }
    
    private func startUploadingFiles(urls: [URL]) {
        for url in urls {
            let fileName = url.lastPathComponent
            
            // Check if file is already being uploaded
            guard !uploadingFiles.contains(where: { $0.fileURL == url }) else {
                continue
            }
            
            let uploadingFile = UploadingFile(fileName: fileName, fileURL: url)
            uploadingFiles.append(uploadingFile)
            
            // Simulate upload with progress
            simulateUpload(for: uploadingFile.id, url: url)
        }
    }
    
    // Mock
    private func simulateUpload(for id: UUID, url: URL) {
        guard let index = uploadingFiles.firstIndex(where: { $0.id == id }) else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            Task { @MainActor in
                if let currentIndex = self.uploadingFiles.firstIndex(where: { $0.id == id }) {
                    if self.uploadingFiles[currentIndex].progress < 1.0 {
                        self.uploadingFiles[currentIndex].progress += 0.02
                    } else {
                        self.uploadingFiles[currentIndex].isCompleted = true
                        self.completedUploads.append(url)
                        timer.invalidate()
                    }
                } else {
                    timer.invalidate()
                }
            }
        }
    }
    
    // Called when Continue button is clicked, ketika continue di klik baru lanjut
    func saveCompletedUploads() {
        for url in completedUploads {
            savePDFToLocal(url: url)
        }
        
        // Clear temporary storage
        completedUploads.removeAll()
        uploadingFiles.removeAll()
        selectedFiles.removeAll()
    }
    
    func clearSelectedFiles() {
        selectedFiles.removeAll()
        uploadingFiles.removeAll()
        completedUploads.removeAll()
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
            
            // Check if file already exists in the array
            if !files.contains(where: { $0.fileURL == destinationURL }) {
                files.append(newFile)
            }
            
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
