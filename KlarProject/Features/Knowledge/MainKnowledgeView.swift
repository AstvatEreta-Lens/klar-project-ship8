//
//  KnowledgePage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import SwiftUI

struct KnowledgePage: View {

    @State private var title: String = NSLocalizedString("Knowledge", comment : "")
    @State private var selectedTab: Int = 0
    @StateObject private var viewModel = KnowledgeViewModel()
    @ObservedObject private var evaluationViewModel = EvaluationViewModel.shared
    @State private var showAddFilesView: Bool = false
    
    
    var body: some View {
        GeometryReader { geometry in
            let sidebarWidth = max(350, min(440, geometry.size.width * 0.3))
            ZStack {
                HStack(spacing: 0) {

                    VStack(alignment: .center, spacing: 0) {

                        VStack(alignment: .leading, spacing: 12) {
                            Text(title)
                                .foregroundColor(Color.sectionHeader)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .layoutPriority(1)

                            CustomSegmentPicker1(selectedTab : $selectedTab)
                                .frame(maxWidth: sidebarWidth - 28, maxHeight: 36)
                        }
                        .padding(.horizontal, 14)
                        .padding(.top, 20)
                        .tint(Color.sectionHeader)
                        .allowsHitTesting(true)

                        Divider()
                            .background(Color.borderColor)

                        if selectedTab == 0 {
                            KnowledgeView(
                                viewModel: viewModel,
                                action: {},
                                onAddFiles: {
                                    showAddFilesView = true
                                }
                            )
                            .allowsHitTesting(!showAddFilesView && !viewModel.showDeleteAlert)
                        } else if selectedTab == 1 {
                            EvaluationView(evaluationViewModel: evaluationViewModel)
                                .allowsHitTesting(!showAddFilesView && !viewModel.showDeleteAlert)
                        }

                        Spacer()
                    }
                    .frame(width: sidebarWidth)
                    .background(Color.backgroundPrimary)
                    
                    Divider()
                        .frame(height: geometry.size.height)
                        .background(Color.borderColor)
                    
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                        
                        if selectedTab == 0, let selectedPDF = viewModel.selectedPDF {
                            PDFViewer(pdfURL: selectedPDF.fileURL)
                                .padding()
                        } else if selectedTab == 0 {
                            VStack {
                                Image("Logo Placeholder No Convo")
                                    .frame(width: 213, height: 48)
                                Text("Select a file to see the content")
                                    .font(.caption)
                                    .foregroundColor(Color.secondaryText)
                            }
                        } else if selectedTab == 1, let conversation = evaluationViewModel.selectedConversation {
                            EvaluationDetailView(
                                conversation: conversation,
                                canApprove: evaluationViewModel.canApprove(conversation),
                                onRemove: {
                                    evaluationViewModel.removeConversation(conversation)
                                },
                                onEdit: {
                                    // add edit logic
                                },
                                onApprove: {
                                    evaluationViewModel.approveConversation(conversation)
                                }
                            )
                            .padding()
                        } else if selectedTab == 1 {
                            VStack(spacing: 12) {
                                Image("Logo Placeholder No Convo")
                                    .foregroundColor(Color.secondaryText.opacity(0.6))
                                
                                Text("Select a conversation to view evaluation details")
                                    .font(.caption)
                                    .foregroundColor(Color.secondaryText)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .allowsHitTesting(!showAddFilesView && !viewModel.showDeleteAlert)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.backgroundPrimary)
                .background(Color.backgroundPrimary)
                .blur(radius: showAddFilesView || viewModel.showDeleteAlert ? 3 : 0)
                
                // Add Files View Overlay
                if showAddFilesView {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showAddFilesView = false
                        }
                    
                    AddFilesView(
                        viewModel: viewModel,
                        closeAction: {
                            showAddFilesView = false
                        },
                        continueAction: {
                            showAddFilesView = false
                        }
                    )
                    .transition(.opacity.combined(with: .scale))
                }
                
                // Delete PDF Alert Overlay - MUNCUL DI TENGAH SELURUH VIEW
                if viewModel.showDeleteAlert, let pdfToDelete = viewModel.pdfToDelete {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.cancelDeletePDF()
                            }
                        }
                    
                    DeletePDFAlert(
                        pdfDocument: pdfToDelete,
                        deleteAction: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.confirmDeletePDF()
                            }
                        },
                        cancelAction: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.cancelDeletePDF()
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .environmentObject(viewModel)
        .animation(.easeInOut(duration: 0.3), value: showAddFilesView)
        .animation(.easeInOut(duration: 0.3), value: viewModel.showDeleteAlert)
    }
}


#Preview {
    KnowledgePage()
        .padding(.leading)
}
