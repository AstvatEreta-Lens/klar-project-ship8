//
//  KnowledgeSidebar.swift
//  KlarProject
//
//  Created by Claude Code
//

import SwiftUI

struct KnowledgeSidebar: View {
    @ObservedObject var viewModel: KnowledgeViewModel
    @ObservedObject var evaluationViewModel: EvaluationViewModel
    @Binding var selectedTab: Int
    @Binding var showAddFilesView: Bool
    let sidebarWidth: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Section
            KnowledgeHeader(selectedTab: $selectedTab, sidebarWidth: sidebarWidth)

            Divider()
                .background(Color.borderColor)

            // Tab Content
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
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Header Component
struct KnowledgeHeader: View {
    @Binding var selectedTab: Int
    let sidebarWidth: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(NSLocalizedString("Knowledge", comment: ""))
                .foregroundColor(Color.sectionHeader)
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .truncationMode(.tail)

            CustomSegmentPicker1(selectedTab: $selectedTab)
                .frame(maxWidth: sidebarWidth - 28, maxHeight: 36)
        }
        .padding(.horizontal, 14)
        .padding(.top, 20)
    }
}
