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
        GeometryReader { geometry in
            HStack{
                VStack(alignment: .leading){
                    // Add Files Button
                    HStack{
                        Button(action: onAddFiles){
                            ZStack(alignment : .leading){
                                HStack{
                                    Image(systemName: "plus")
                                        .foregroundColor(Color.white)
                                        .font(.body)
                                    Text("Add Files")
                                        .foregroundColor(Color.white)
                                        .font(.body)
                                }
                                Spacer()
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
                        .padding(.trailing)
                    }
                    
                    HStack{
                        Text("Uploaded Files")
                            .padding(.leading, 14)
                            .foregroundColor(Color.textRegular)
                        
                        ZStack {
                            Circle()
                                .fill(Color.sectionHeader)
                                .frame(width: 16, height: 16)
                            
                            Text("\(viewModel.uploadedFiles)")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top)
                    
                    // PDF ScrollView dengan adaptive height
                    pdfScrollView(height: geometry.size.height)
                }
                .padding(.top)
                .background(Color.backgroundPrimary)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
    }
    
    private func pdfScrollView(height: CGFloat) -> some View {
        let scrollHeight = max(982, (height - 300) / 2)
        
        return ScrollView {
            LazyVStack(spacing: 6) {
                ForEach(viewModel.files) { pdf in
                    PDFCardView(
                        pdfDocument: pdf,
                        action: {
                            // Handle delete request
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
                
                // Empty state jika tidak ada hasil
                if viewModel.files.isEmpty {
                    emptyPDFState
                }
            }
            .padding(8)
        }
        .background(Color.backgroundPrimary)
        .frame(height: scrollHeight)
        .scrollIndicators(.visible)
    }
    
    private var emptyPDFState: some View {
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
        .environmentObject(viewModel)
    }
}



#Preview {
    KnowledgeView(viewModel: KnowledgeViewModel(), action: {}, onAddFiles: {})
        .padding()
}
