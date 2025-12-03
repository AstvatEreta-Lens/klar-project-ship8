//
//  KnowledgePage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//  Refactored by Claude Code
//
import SwiftUI

struct KnowledgePage: View {
    // MARK: - Properties
    // Gunakan @StateObject dengan init yang lebih aman
    @StateObject private var viewModel = KnowledgeViewModel()
    @State private var selectedTab: Int = 0
    @State private var showAddFilesView: Bool = false
    
    // Ambil EvaluationViewModel sebagai EnvironmentObject atau parameter
    // daripada menggunakan .shared langsung di @ObservedObject
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            contentView(geometry: geometry)
        }
        .environmentObject(viewModel)
        .animation(.easeInOut(duration: KnowledgeConstants.animationDuration), value: showAddFilesView)
        .animation(.easeInOut(duration: KnowledgeConstants.animationDuration), value: viewModel.showDeleteAlert)
    }
    
    // MARK: - Content Builder
    @ViewBuilder
    private func contentView(geometry: GeometryProxy) -> some View {
        ZStack {
            MainContentView(
                viewModel: viewModel,
                evaluationViewModel: EvaluationViewModel.shared,
                selectedTab: $selectedTab,
                showAddFilesView: $showAddFilesView,
                sidebarWidth: calculateSidebarWidth(for: geometry.size.width)
            )
            .blur(radius: shouldBlur ? KnowledgeConstants.overlayBlurRadius : 0)
            
            KnowledgeOverlays(
                viewModel: viewModel,
                showAddFilesView: $showAddFilesView
            )
        }
        .background(Color.backgroundPrimary)
    }
    
    // MARK: - Helpers
    private func calculateSidebarWidth(for width: CGFloat) -> CGFloat {
        guard width > 0 else { return KnowledgeConstants.sidebarMinWidth }
        let calculated = width * KnowledgeConstants.sidebarWidthRatio
        return max(KnowledgeConstants.sidebarMinWidth, min(KnowledgeConstants.sidebarMaxWidth, calculated))
    }
    
    private var shouldBlur: Bool {
        showAddFilesView || viewModel.showDeleteAlert
    }
}

// MARK: - Main Content View
private struct MainContentView: View {
    @ObservedObject var viewModel: KnowledgeViewModel
    @ObservedObject var evaluationViewModel: EvaluationViewModel
    @Binding var selectedTab: Int
    @Binding var showAddFilesView: Bool
    let sidebarWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            // Left Sidebar
            KnowledgeSidebar(
                viewModel: viewModel,
                evaluationViewModel: evaluationViewModel,
                selectedTab: $selectedTab,
                showAddFilesView: $showAddFilesView,
                sidebarWidth: sidebarWidth
            )
            
            Divider()
                .frame(maxHeight: .infinity)
                .background(Color.borderColor)
            
            // Right Content Area
            KnowledgeContentArea(
                viewModel: viewModel,
                evaluationViewModel: evaluationViewModel,
                selectedTab: selectedTab
            )
            .allowsHitTesting(!showAddFilesView && !viewModel.showDeleteAlert)
        }
        .background(Color.backgroundPrimary)
    }
}
