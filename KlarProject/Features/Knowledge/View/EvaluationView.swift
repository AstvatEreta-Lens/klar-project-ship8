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
    }
    
    private var filteredConversations: [Conversation] {
        switch selectedFilter {
        case .all:
            return evaluationViewModel.allConversations
        case .unevaluated:
            return evaluationViewModel.unevaluatedConversations
        case .evaluated:
            return evaluationViewModel.evaluatedConversations
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.secondaryText)
                    .font(.body)
                
                TextField("Search", text: $evaluationViewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.body)
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.borderColor.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 14)
            .padding(.top, 16)
            
            HStack(spacing: 12) {
                ForEach(EvaluationFilter.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.rawValue,
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
    EvaluationView(evaluationViewModel: EvaluationViewModel())
        .frame(width: 399, height: 800)
}

