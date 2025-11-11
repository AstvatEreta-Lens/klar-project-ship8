//
//  KnowledgeView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import SwiftUI

struct KnowledgeView: View {
    @State private var title: String = "Knowledge"
    @State private var selectedTab: Int = 0
    @ObservedObject var viewModel : KnowledgeViewModel
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading){
                HStack{
                    // Title
                    Text(title)
                        .foregroundColor(Color.primaryText)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading, 14)
                        .padding(.top)
                    Spacer()
                    
                    // Picker
                    Picker("", selection: $selectedTab) {
                        Label("Files", systemImage: "doc")
                            .tag(0)
                        Label("Evaluation", systemImage: "doc.text.magnifyingglass")
                            .tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.top)
                    .padding(.trailing)
                }
                
                // Divider
                Divider()
                    .foregroundColor(Color.primaryText)
                
                // Add Files Button
                HStack{
                    Button(action : action){
                        ZStack{
                            HStack{
                                Image(systemName: "plus")
                                    .foregroundColor(Color.border)
                                    .font(.body)
                                Text("Add Files")
                                    .foregroundColor(Color.border)
                                    .font(.body)
                            }
                        }
                        .frame(width: 106, height: 36)
                    }
                    .background(LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.42, green: 0.68, blue: 0.74),
                            Color(red: 0.25, green: 0.48, blue: 0.55)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
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
            .background(Color.backgroundPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
    
    private func pdfScrollView(height: CGFloat) -> some View {
        let scrollHeight = max(982, (height - 300) / 2)
        
        return ScrollView {
            LazyVStack(spacing: 6) {
                ForEach(PDFDocument.dummyPDFs) { pdf in
                    PDFCardView(
                        pdfDocument: pdf,
                        action: {
                            // Handle PDF selection
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
                if PDFDocument.dummyPDFs.isEmpty {
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
    KnowledgeView(viewModel: KnowledgeViewModel(), action: {})
        .frame(width: 399, height: 982)
        .padding()
}
