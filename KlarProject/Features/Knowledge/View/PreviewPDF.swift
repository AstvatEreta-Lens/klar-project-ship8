//
//  PreviewPDF.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 11/11/25.
//

import SwiftUI
import PDFKit

struct KnowledgeBaseView: View {
    @StateObject private var viewModel = KnowledgeViewModel()
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar untuk daftar file
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("PDF Files")
                        .font(.headline)
                    Spacer()
                    Button {
                        viewModel.uploadPDF()
                    } label: {
                        Label("Upload", systemImage: "plus.circle.fill")
                    }
                    .buttonStyle(.borderless)
                }
                .padding(.horizontal)
                
                List(viewModel.files) { pdf in
                    Button(action: {
                        viewModel.selectedPDF = pdf
                    }) {
                        VStack(alignment: .leading) {
                            Text(pdf.title)
                                .font(.body)
                            Text(pdf.formattedDateAdded)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(width: 250)
            .background(Color(nsColor: .windowBackgroundColor))
            
            Divider()
            
            // Area Preview PDF
            ZStack {
                if let selectedPDF = viewModel.selectedPDF {
                    PDFViewer(pdfURL: selectedPDF.fileURL)
                        .padding()
                } else {
                    Text("Pilih atau unggah PDF untuk melihat preview")
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct PDFViewer: NSViewRepresentable {
    let pdfURL: URL

    func makeNSView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = .clear
        pdfView.document = PDFKit.PDFDocument(url: pdfURL)
        return pdfView
    }

    func updateNSView(_ nsView: PDFKit.PDFView, context: Context) {
        nsView.document = PDFKit.PDFDocument(url: pdfURL)
    }
}


#Preview {
    KnowledgeBaseView()
}

