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
//    @Published var files: [PDFDocument] = []
    @Published var files: [PDFDocument] = PDFDocument.dummyPDFs // Sementara pakai ini
    @Published var selectedPDF: PDFDocument?
    @Published var pdfDocuments: [PDFDocument] = PDFDocument.dummyPDFs
    
    func searchFile () {
        
    }
    
    var uploadedFiles: Int {
        return files.count
    }
    
    func selectPDF(_ pdf: PDFDocument) {
        selectedPDF = pdf
    }
}
