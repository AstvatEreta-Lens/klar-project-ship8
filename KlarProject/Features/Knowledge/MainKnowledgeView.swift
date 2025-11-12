//
//  KnowledgePage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import SwiftUI

struct KnowledgePage: View {
    
    @State private var title: String = "Knowledge"
    @State private var selectedTab: Int = 0
    @StateObject private var viewModel = KnowledgeViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                
                // 🔹 Sidebar Area (Knowledge Section)
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: - Header (Fixed di pojok kiri atas)
                    HStack {
                        Text(title)
                            .foregroundColor(Color.primaryText)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 14)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .layoutPriority(1)
                        
                        Spacer()
                        
                        Picker("", selection: $selectedTab) {
                            Text("Files").tag(0)
                            Text("Evaluation").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 180)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .background(
                            Capsule()
                                .fill(Color.sectionHeader.opacity(0.18))
                        )
                        .clipShape(Capsule())
                        .padding(.trailing, 14)
                    }
                    .frame(height: 60)
                    .background(Color.backgroundPrimary)
                    .padding(.top, 10)
                    
                    // MARK: - Konten Berdasarkan Tab
                    if selectedTab == 0 {
                        // File Tab (KnowledgeView)
                        KnowledgeView(viewModel: viewModel, action: {})
                            .frame(width: 399)
                    } else if selectedTab == 1 {
                        // Evaluation Tab
                        EvaluationView(viewModel: ConversationListViewModel())
                            .frame(width: 399, height: geometry.size.height)
                    }
                    
                    Spacer()
                }
                .frame(width: 440)
                .background(Color.backgroundPrimary)
                
                // MARK: - Divider (pemisah dari area kanan)
                Divider()
                    .frame(height: geometry.size.height)
                    .background(Color.borderColor)
                
                // MARK: - PDF Preview Area
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    if selectedTab == 0, let selectedPDF = viewModel.selectedPDF {
                        PDFViewer(pdfURL: selectedPDF.fileURL)
                            .padding()
                    } else if selectedTab == 0 {
                        VStack {
                            Image("LogoFix")
                                .frame(width: 213, height: 48)
                            Text("Select a file to see the content")
                                .foregroundColor(Color.secondaryText)
                        }
                    } else {
                        VStack {
                            Text("Evaluation Panel")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.backgroundPrimary)
        }
        .environmentObject(viewModel)
    }
}


#Preview {
    KnowledgePage()
        .padding()
}
