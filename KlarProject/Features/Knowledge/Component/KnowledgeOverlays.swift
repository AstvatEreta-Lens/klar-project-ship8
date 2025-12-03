//
//  KnowledgeOverlays.swift
//  KlarProject
//
//  Created by Claude Code
//

import SwiftUI

struct KnowledgeOverlays: View {
    @ObservedObject var viewModel: KnowledgeViewModel
    @Binding var showAddFilesView: Bool

    var body: some View {
        ZStack {
            // Add Files View Overlay
            if showAddFilesView {
                AddFilesOverlay(
                    viewModel: viewModel,
                    showAddFilesView: $showAddFilesView
                )
            }

            // Delete PDF Alert Overlay
            if viewModel.showDeleteAlert, let pdfToDelete = viewModel.pdfToDelete {
                DeletePDFOverlay(
                    viewModel: viewModel,
                    pdfToDelete: pdfToDelete
                )
            }
        }
    }
}

// MARK: - Add Files Overlay
private struct AddFilesOverlay: View {
    @ObservedObject var viewModel: KnowledgeViewModel
    @Binding var showAddFilesView: Bool

    var body: some View {
        ZStack {
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
    }
}

// MARK: - Delete PDF Overlay
private struct DeletePDFOverlay: View {
    @ObservedObject var viewModel: KnowledgeViewModel
    let pdfToDelete: PDFDocument

    var body: some View {
        ZStack {
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
