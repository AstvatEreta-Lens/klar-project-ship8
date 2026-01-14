//
//  EvaluationViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 11/11/25.
//

import SwiftUI
import Combine

@MainActor
class EvaluationViewModel: ObservableObject {
    
    @Published var evaluatingChat : Conversation?
    
    
    
    func handleEvaluation(for conversation: Conversation) {
        self.evaluatingChat = conversation
    }
}
