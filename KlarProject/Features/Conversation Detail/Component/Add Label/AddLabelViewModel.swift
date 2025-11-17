//
//  AddLabelViewModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 06/11/25.
//

import Foundation

extension Conversation {
    // Update label dengan value baru
    func updatinglabel(_ newlabel: [LabelType]) -> Conversation {
        return Conversation(
            id: self.id,
            name: self.name,
            message: self.message,
            time: self.time,
            profileImage: self.profileImage,
            unreadCount: self.unreadCount,
            hasWhatsApp: self.hasWhatsApp,
            phoneNumber: self.phoneNumber,
            handlerType: self.handlerType,
            status: self.status,
            label: newlabel, // Updated value
            handledBy: self.handledBy,
            handledAt: self.handledAt,
            isEvaluated: false,
            seenBy: self.seenBy,
            internalNotes: self.internalNotes
        )
    }
    
    // Add label to existing label
    func addingLabel(_ label: LabelType) -> Conversation {
        var updatedlabel = self.label
        if !updatedlabel.contains(label) {
            updatedlabel.append(label)
        }
        return self.updatinglabel(updatedlabel)
    }
    
    // Add multiple label to existing label
    func addinglabel(_ newlabel: [LabelType]) -> Conversation {
        var updatedlabel = self.label
        for label in newlabel {
            if !updatedlabel.contains(label) {
                updatedlabel.append(label)
            }
        }
        return self.updatinglabel(updatedlabel)
    }
    
    // Removes a specific label
    func removingLabel(_ label: LabelType) -> Conversation {
        var updatedlabel = self.label
        updatedlabel.removeAll { $0 == label }
        return self.updatinglabel(updatedlabel)
    }
    
    // Removes multiple label
    func removinglabel(_ labelToRemove: [LabelType]) -> Conversation {
        var updatedlabel = self.label
        updatedlabel.removeAll { labelToRemove.contains($0) }
        return self.updatinglabel(updatedlabel)
    }
    
    // Clears all label
    func clearinglabel() -> Conversation {
        return self.updatinglabel([])
    }
    
    // Creates a copy of the conversation with updated internal notes
    func updatingInternalNotes(_ newNotes: [InternalNote]) -> Conversation {
        return Conversation(
            id: self.id,
            name: self.name,
            message: self.message,
            time: self.time,
            profileImage: self.profileImage,
            unreadCount: self.unreadCount,
            hasWhatsApp: self.hasWhatsApp,
            phoneNumber: self.phoneNumber,
            handlerType: self.handlerType,
            status: self.status,
            label: self.label,
            handledBy: self.handledBy,
            handledAt: self.handledAt,
            isEvaluated: false,
            seenBy: self.seenBy,
            internalNotes: newNotes  // Updated value
        )
    }
    
    // Creates a copy of the conversation with updated status
    func updatingStatus(_ newStatus: statusType?) -> Conversation {
        return Conversation(
            id: self.id,
            name: self.name,
            message: self.message,
            time: self.time,
            profileImage: self.profileImage,
            unreadCount: self.unreadCount,
            hasWhatsApp: self.hasWhatsApp,
            phoneNumber: self.phoneNumber,
            handlerType: self.handlerType,
            status: newStatus,  // Updated value
            label: self.label,
            handledBy: self.handledBy,
            handledAt: self.handledAt,
            isEvaluated: true,
            seenBy: self.seenBy,
            internalNotes: self.internalNotes,
        )
    }
    
    // Creates a copy of the conversation with updated seen by records
    func updatingSeenBy(_ newSeenBy: [SeenByRecord]) -> Conversation {
        return Conversation(
            id: self.id,
            name: self.name,
            message: self.message,
            time: self.time,
            profileImage: self.profileImage,
            unreadCount: self.unreadCount,
            hasWhatsApp: self.hasWhatsApp,
            phoneNumber: self.phoneNumber,
            handlerType: self.handlerType,
            status: self.status,
            label: self.label,
            handledBy: self.handledBy,
            handledAt: self.handledAt,
            
            isEvaluated: false,
            seenBy: newSeenBy,  // Updated value
            internalNotes: self.internalNotes,
        )
    }
    
    // Adds a new internal note to the conversation
    func addingInternalNote(_ note: InternalNote) -> Conversation {
        var updatedNotes = self.internalNotes
        updatedNotes.append(note)
        return self.updatingInternalNotes(updatedNotes)
    }
    
    // Adds a seen by record to the conversation
    func addingSeenByRecord(_ record: SeenByRecord) -> Conversation {
        var updatedSeenBy = self.seenBy
        updatedSeenBy.append(record)
        return self.updatingSeenBy(updatedSeenBy)
    }
}

extension Conversation {
    // Check if conversation has a specific label
    func hasLabel(_ label: [LabelType]) -> Bool {
        return label.contains(label)
    }
    
    // Check if conversation has any of the specified label
    func hasAnyLabel(_ label: [LabelType]) -> Bool {
        return !Set(self.label).intersection(Set(label)).isEmpty
    }
    
    // Check if conversation has all of the specified label
    func hasAlllabel(_ label: [LabelType]) -> Bool {
        return Set(label).isSubset(of: Set(self.label))
    }
    
    // Count of label
    var labelCount: Int {
        return label.count
    }
}


class ConversationBuilder {
    private var conversation: Conversation
    
    init(from conversation: Conversation) {
        self.conversation = conversation
    }
    
    func withlabel(_ label: [LabelType]) -> ConversationBuilder {
        conversation = conversation.updatinglabel(label)
        return self
    }
    
    func addingLabel(_ label: LabelType) -> ConversationBuilder {
        conversation = conversation.addingLabel(label)
        return self
    }
    
    func removingLabel(_ label: LabelType) -> ConversationBuilder {
        conversation = conversation.removingLabel(label)
        return self
    }
    
    func withStatus(_ status: statusType?) -> ConversationBuilder {
        conversation = conversation.updatingStatus(status)
        return self
    }
    
    func withInternalNote(_ note: InternalNote) -> ConversationBuilder {
        conversation = conversation.addingInternalNote(note)
        return self
    }
    
    func build() -> Conversation {
        return conversation
    }
}

class AddLabelViewModel: ObservableObject {
    @Published var selectedLabels: Set<LabelType> = []
    
    // Initialize with multiple existing labels
    init(existingLabels: [LabelType] = []) {
        self.selectedLabels = Set(existingLabels)
    }
    
    // Convenience init for single label
    convenience init(existingLabel: LabelType?) {
        if let label = existingLabel {
            self.init(existingLabels: [label])
        } else {
            self.init(existingLabels: [])
        }
    }
    
    func toggleLabel(_ label: LabelType) {
        if selectedLabels.contains(label) {
            selectedLabels.remove(label)
        } else {
            selectedLabels.insert(label)
        }
    }
    
    func isLabelSelected(_ label: LabelType) -> Bool {
        selectedLabels.contains(label)
    }
}
