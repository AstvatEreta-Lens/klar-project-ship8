//
//  KnowledgeContentArea.swift
//  KlarProject
//
//  Created by Claude Code
//

import SwiftUI

struct KnowledgeContentArea: View {
    @ObservedObject var viewModel: KnowledgeViewModel
    @ObservedObject var evaluationViewModel: EvaluationViewModel
    let selectedTab: Int

    var body: some View {
        Group {
            if selectedTab == 0 {
                FilesContentView(viewModel: viewModel)
            } else if selectedTab == 1 {
                EvaluationContentView(evaluationViewModel: evaluationViewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Files Content
private struct FilesContentView: View {
    @ObservedObject var viewModel: KnowledgeViewModel

    var body: some View {
        if let selectedPDF = viewModel.selectedPDF {
            PDFViewer(pdfURL: selectedPDF.fileURL)
                .padding()
        } else {
            EmptyStateView(
                message: "Select a file to see the content",
                systemImage: nil
            )
        }
    }
}

// MARK: - Evaluation Content
private struct EvaluationContentView: View {
    @ObservedObject var evaluationViewModel: EvaluationViewModel

    var body: some View {
        if let conversation = evaluationViewModel.selectedConversation {
            EvaluationDetailView(
                conversation: conversation,
                canApprove: evaluationViewModel.canApprove(conversation),
                onRemove: {
                    evaluationViewModel.removeConversation(conversation)
                },
                onEdit: {
                    // Add edit logic
                },
                onApprove: {
                    evaluationViewModel.approveConversation(conversation)
                }
            )
            .padding()
        } else {
            EmptyStateView(
                message: "Select a conversation to view evaluation details",
                systemImage: nil
            )
        }
    }
}

// MARK: - Empty State Component
private struct EmptyStateView: View {
    let message: String
    let systemImage: String?

    var body: some View {
        VStack(spacing: 8) {
            Image("Logo Placeholder No Convo")
                .resizable()
                .scaledToFit()
                .frame(width: 213, height: 48)

            Text(message)
                .font(.caption)
                .foregroundColor(Color.secondaryText)
        }
    }
}
