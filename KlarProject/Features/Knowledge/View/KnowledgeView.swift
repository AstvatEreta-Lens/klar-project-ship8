//
//  KnowledgeView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import SwiftUI

struct KnowledgeView: View {
    @ObservedObject var viewModel : KnowledgeViewModel
    let action: () -> Void
    let onAddFiles: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Add Files Button
            HStack(spacing: 8) {
                Button(action: onAddFiles) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .foregroundColor(Color.white)
                            .font(.title2)
                        Text("Add Files")
                            .foregroundColor(Color.white)
                            .font(.title2)
                    }
                    .frame(width: 106, height: 36)
                }
                .background(Color.sectionHeader)
                .cornerRadius(11)
                .padding(.leading, 14)

                // Search Bar
                SearchBar(
                    text: $viewModel.searchText,
                    onSearch: {
                        viewModel.searchFile()
                    }
                )
                .padding(.trailing, 14)
            }
            .padding(.top, 8)

            HStack(spacing: 8) {
                Text("Uploaded Files")
                    .padding(.leading, 14)
                    .foregroundColor(Color.textRegular)

                ZStack {
                    Circle()
                        .fill(Color.sectionHeader)
                        .frame(width: 16, height: 16)

                    Text("\(viewModel.filteredFiles.count)")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 8)

            // PDF ScrollView
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(viewModel.filteredFiles) { pdf in
                        PDFCardView(
                            pdfDocument: pdf,
                            action: {
                                viewModel.requestDeletePDF(pdf)
                            },
                            isSelected: viewModel.selectedPDF?.id == pdf.id
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.selectPDF(pdf)
                            }
                        }
                    }

                    // Empty state
                    if viewModel.filteredFiles.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)

                            Text("No PDFs found")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            Text("Try adjusting your search")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                }
                .padding(8)
            }
            .background(Color.backgroundPrimary)
            .scrollIndicators(.visible)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}



#Preview {
    KnowledgeView(viewModel: KnowledgeViewModel(), action: {}, onAddFiles: {})
        .padding()
}
