//
//  KnowledgePage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//
import SwiftUI
import PDFKit

struct KnowledgeFilesSection: View {
    @ObservedObject var viewModel: KnowledgeViewModel

    var body: some View {
        HStack(spacing: 0) {
            // Sidebar: List Files
            VStack {
                HStack {
                    Text("Files")
                        .font(.headline)
                    Spacer()
                    Button {
                        viewModel.uploadPDF()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.borderless)
                }
                .padding(.horizontal)

                List(viewModel.files) { file in
                    Button {
                        viewModel.selectedPDF = file
                    } label: {
                        VStack(alignment: .leading) {
                            Text(file.title)
                                .font(.body)
                            Text(file.formattedDateAdded)
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
                .background(Color.borderColor)

            // PDF Preview Area
            ZStack {
                if let selectedPDF = viewModel.selectedPDF {
                    PDFViewer(pdfURL: selectedPDF.fileURL)
                        .padding()
                } else {
                    VStack {
                        Image("LogoFix")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 213, height: 48)
                        Text("Select a file to see the content")
                            .font(.callout)
                            .foregroundColor(Color.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.white)
    }
}

#Preview {
    KnowledgeFilesSection(viewModel: KnowledgeViewModel())
}
