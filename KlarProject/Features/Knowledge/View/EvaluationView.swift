//
//  EvaluationView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 13/11/25.
//

import SwiftUI

struct EvaluationView: View {
    @ObservedObject var evaluationViewModel: EvaluationViewModel
    @State private var selectedFilter: EvaluationFilter = .all
    
    enum EvaluationFilter: String, CaseIterable {
        case all = "All"
        case unevaluated = "Unevaluated"
        case evaluated = "Evaluated"
        
        var localizedTitle: String {
            switch self {
            case .all:
                return NSLocalizedString("All", comment: "Filter to show all conversations")
            case .unevaluated:
                return NSLocalizedString("Unevaluated", comment: "Filter to show unevaluated conversations")
            case .evaluated:
                return NSLocalizedString("Evaluated", comment: "Filter to show evaluated conversations")
            }
        }
    }
    
    private var filteredConversations: [Conversation] {
        switch selectedFilter {
        case .all:
            // Return unevaluated first, then evaluated
            return evaluationViewModel.unevaluatedConversations + evaluationViewModel.evaluatedConversations
        case .unevaluated:
            return evaluationViewModel.unevaluatedConversations
        case .evaluated:
            return evaluationViewModel.evaluatedConversations
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                SearchBar(
                    text: $evaluationViewModel.searchText,
                    onSearch: {
                        // Search is performed automatically via binding
                    }
                )
            }
            .padding(10)
            .cornerRadius(8)
            .padding(.top, 16)
            
            HStack(spacing: 12) {
                ForEach(EvaluationFilter.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.localizedTitle,
                        count: countFor(filter),
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    if selectedFilter == .all {
                        // Show unevaluated conversations first
                        ForEach(evaluationViewModel.searchConversations(in: evaluationViewModel.unevaluatedConversations)) { conversation in
                            EvaluationCard(
                                conversation: conversation,
                                state: evaluationViewModel.getCardState(for: conversation),
                                onTap: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        evaluationViewModel.selectConversation(conversation)
                                    }
                                }
                            )
                        }
                        
                        // Then show evaluated conversations
                        ForEach(evaluationViewModel.searchConversations(in: evaluationViewModel.evaluatedConversations)) { conversation in
                            EvaluationCard(
                                conversation: conversation,
                                state: evaluationViewModel.getCardState(for: conversation),
                                onTap: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        evaluationViewModel.selectConversation(conversation)
                                    }
                                }
                            )
                        }
                    } else {
                        // Show filtered conversations
                        ForEach(evaluationViewModel.searchConversations(in: filteredConversations)) { conversation in
                            EvaluationCard(
                                conversation: conversation,
                                state: evaluationViewModel.getCardState(for: conversation),
                                onTap: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        evaluationViewModel.selectConversation(conversation)
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, 12)
            }
        }
        .background(Color.backgroundPrimary)
    }
    
    // MARK: - Helper Functions
    
    private func countFor(_ filter: EvaluationFilter) -> Int {
        switch filter {
        case .all:
            return evaluationViewModel.allConversations.count
        case .unevaluated:
            return evaluationViewModel.unevaluatedCount
        case .evaluated:
            return evaluationViewModel.evaluatedCount
        }
    }
}

// MARK: - Previews

#Preview("Evaluation View") {
    EvaluationView(evaluationViewModel: EvaluationViewModel.shared)
        .frame(width: 399, height: 800)
}

