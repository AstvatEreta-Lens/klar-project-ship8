//
//  ConversationListViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 28/10/25.
//

import Foundation
import Combine

class ConversationListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedFilter = "All"
    @Published var selectedConversation : Conversation?
    @Published var humanConversation : [Conversation] = []
    @Published var aiConversation : [Conversation] = []
    
    //MARK: Computed Properties
    
    var chatCount : [Conversation]{
        humanConversation + aiConversation
    }
    
    var unreadCount : Int{
        humanConversation.filter{$0.unreadCount > 0}.count
    }
    
    var unresolvedCount : Int {
        aiConversation.filter { conversation in
            if let status = conversation.status {
                return status == .pending || status == .open
            }
            return false
        }.count // return count
    }
    
    
    //MARK: Sorting
    var sortedHumanConversation : [Conversation]{
        humanConversation.sorted{ conv1, conv2 in
            conv1.timeInMinutes > conv2.timeInMinutes
        }
    }
    
    var sortedAiConversations: [Conversation] {
        aiConversation.sorted { conv1, conv2 in
            if conv1.sortPriority != conv2.sortPriority {
                return conv1.sortPriority < conv2.sortPriority
            }
            return conv1.timeInMinutes > conv2.timeInMinutes
        }
    }
    
    // Filter which is human which is AI
    var filterHumanConvo : [Conversation] {
        let sorted = sortedHumanConversation
        
        switch selectedFilter {
        case "Unread" :
            return sorted.filter {$0.unreadCount > 0}
        default :
            return sorted
        }
    }
    var filterAiConvo : [Conversation] {
        let sorted = sortedAiConversations
        
        switch selectedFilter {
            
        case "Resolved" :
            return sorted.filter {$0.unreadCount > 0}
            
        case "Unresolved" :
            return sorted.filter { conversation in
                if let status = conversation.status{
                    return status == .pending || status == .open
                }
                return false
            }
            default :
                return sorted
        }
    }
    
    init(){
        loadConversations()
    }
    
    func loadConversations(){
        humanConversation = Conversation.humanDummyData
        aiConversation = Conversation.aiDummyData
    }
    
    func selectConversation(_ conversation: Conversation){
        selectedConversation = conversation
        print("Selected Conversation : \(conversation.name)")
    }
    
    func applyFilter(_ filter : String){
        selectedFilter = filter
    }
    
    func searchConversations() {
        print("Searching For : \(searchText)")
    }
}
