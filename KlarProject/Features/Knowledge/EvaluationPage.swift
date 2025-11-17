//
//  EvaluationPage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 11/11/25.
//

import SwiftUI

struct EvaluationPage: View {
    @ObservedObject private var evaluationViewModel = EvaluationViewModel.shared
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Header
                EvaluationView(evaluationViewModel: evaluationViewModel)
                    .frame(minWidth: 350, idealWidth: 399, maxWidth: 450)
                    .frame(height: geometry.size.height)
                
                Divider()
                    .frame(height: geometry.size.height)
                    .background(Color.borderColor)
                
                ZStack {
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                    
                    if let conversation = evaluationViewModel.selectedConversation {
                        EvaluationDetailView(
                            conversation: conversation,
                            canApprove: evaluationViewModel.canApprove(conversation),
                            onRemove: {
                                evaluationViewModel.removeConversation(conversation)
                            },
                            onEdit: {
                                // future editing logic
                            },
                            onApprove: {
                                evaluationViewModel.approveConversation(conversation)
                            }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        VStack(spacing: 12) {
                            Image("LogoFix")
                                .resizable()
                                .scaledToFit()
                                .frame(width: min(213, geometry.size.width * 0.2), height: min(48, geometry.size.height * 0.06))
                                .foregroundColor(Color.secondaryText.opacity(0.6))
                            
                            Text("Select a context to evaluate")
                                .font(.headline)
                                .foregroundColor(Color.secondaryText)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .padding()
    }
}

#Preview {
    EvaluationPage()
}
