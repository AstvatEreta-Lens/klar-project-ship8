//
//  DetailViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 09/11/25.
//

import SwiftUI
import Combine


class DetailViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var conversation: Conversation?
    @Published var showingAddLabel = false
    @Published var showingAddCollaborator = false
    @Published var toastManager = ToastManager()
    
    // Callback untuk notify parent view
    var onConversationUpdated: ((Conversation) -> Void)?
    
    // MARK: - Initialization
    
    init(conversation: Conversation? = nil, onConversationUpdated: ((Conversation) -> Void)? = nil) {
        self.conversation = conversation
        self.onConversationUpdated = onConversationUpdated
    }
    
    // MARK: - Label Management
    
    // Toggle label - Add if not exists, Remove if exists
    func toggleLabel(_ label: LabelType) {
        guard var currentConversation = conversation else {
            print("Error: No conversation to update")
            return
        }
        
        var updatedLabels = currentConversation.label
        
        if updatedLabels.contains(label) {
            // Remove label
            updatedLabels.removeAll { $0 == label }
            print("Label removed: \(label.text)")
        } else {
            // Add label
            updatedLabels.append(label)
            print("Label added: \(label.text)")
        }
        
        // Update conversation
        currentConversation = currentConversation.updatinglabel(updatedLabels)
        conversation = currentConversation
        
        // Notify parent
        onConversationUpdated?(currentConversation)
        
        print("Current labels: \(updatedLabels.map { $0.text }.joined(separator: ", "))")
    }
    
    // Delete a specific label from the conversation
    func deleteLabel(_ label: LabelType) {
        guard var currentConversation = conversation else {
            print("Error: No conversation to update")
            // Toast manager
            toastManager.show(.errorWithoutButton)
            return
        }
        
        var updatedLabels = currentConversation.label
        updatedLabels.removeAll { $0 == label }
        
        // Update conversation
        currentConversation = currentConversation.updatinglabel(updatedLabels)
        conversation = currentConversation
        toastManager.show(.successWithoutButton)
        
        // Notify parent
        onConversationUpdated?(currentConversation)
        
        print("Label deleted: \(label.text)")
        // Toast manager
        toastManager.show(.successWithoutButton)
    }
    
    // MARK: - Update Conversation
    
    // Update the current conversation
    func updateConversation(_ newConversation: Conversation) {
        conversation = newConversation
    }
}
