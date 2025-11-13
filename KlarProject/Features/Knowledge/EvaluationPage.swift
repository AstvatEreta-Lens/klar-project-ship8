//
//  EvaluationPage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 11/11/25.
//

import SwiftUI

struct EvaluationPage: View {
    @StateObject private var evaluationViewModel = EvaluationViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                // Header
                EvaluationView(evaluationViewModel: evaluationViewModel)
                    .frame(width: 399, height: geometry.size.height)
                
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
                                .font(.system(size: 48))
                                .foregroundColor(Color.secondaryText.opacity(0.6))
                            
                            Text("Select a context to evaluate")
                                .font(.headline)
                                .foregroundColor(Color.secondaryText)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .padding()
    }
}

#Preview {
    EvaluationPage()
}
