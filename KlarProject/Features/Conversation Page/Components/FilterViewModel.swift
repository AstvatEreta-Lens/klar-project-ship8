//
//  FilterViewModel.swift
//  KlarProject
//
//  Created by Assistant on 04/11/25.
//

import SwiftUI

// MARK: - Active Filter Item

struct ActiveFilter: Identifiable {
    let id = UUID()
    let type: FilterType
    let statusValue: statusType?
    let labelValue: LabelType?
    
    enum FilterType {
        case status
        case label
    }
    
    var displayText: String {
        switch type {
        case .status:
            return statusValue?.text ?? ""
        case .label:
            return labelValue?.text ?? ""
        }
    }
}

// MARK: - Filter ViewModel

class FilterViewModel: ObservableObject {
    // Selected filters
    @Published var selectedStatuses: Set<statusType> = []
    @Published var selectedLabels: Set<LabelType> = []
    
    // Computed property untuk active filters
    var activeFilters: [ActiveFilter] {
        var filters: [ActiveFilter] = []
        
        // Add status filters
        for status in selectedStatuses {
            filters.append(ActiveFilter(
                type: .status,
                statusValue: status,
                labelValue: nil
            ))
        }
        
        // Add label filters
        for label in selectedLabels {
            filters.append(ActiveFilter(
                type: .label,
                statusValue: nil,
                labelValue: label
            ))
        }
        
        return filters
    }
    
    var hasActiveFilters: Bool {
        !selectedStatuses.isEmpty || !selectedLabels.isEmpty
    }
    
    // MARK: - Toggle Methods
    
    func toggleStatus(_ status: statusType) {
        if selectedStatuses.contains(status) {
            selectedStatuses.remove(status)
        } else {
            selectedStatuses.insert(status)
        }
    }
    
    func toggleLabel(_ label: LabelType) {
        if selectedLabels.contains(label) {
            selectedLabels.remove(label)
        } else {
            selectedLabels.insert(label)
        }
    }
    
    func isStatusSelected(_ status: statusType) -> Bool {
        selectedStatuses.contains(status)
    }
    
    func isLabelSelected(_ label: LabelType) -> Bool {
        selectedLabels.contains(label)
    }
    
    // MARK: - Remove Methods
    
    func removeFilter(_ filter: ActiveFilter) {
        switch filter.type {
        case .status:
            if let status = filter.statusValue {
                selectedStatuses.remove(status)
            }
        case .label:
            if let label = filter.labelValue {
                selectedLabels.remove(label)
            }
        }
    }
    
    func clearAllFilters() {
        selectedStatuses.removeAll()
        selectedLabels.removeAll()
    }
    
    // MARK: - Apply Filter
    
    func applyFilters(to conversations: [Conversation]) -> [Conversation] {
        var filtered = conversations
        
        // Filter by status
        if !selectedStatuses.isEmpty {
            filtered = filtered.filter { conversation in
                guard let status = conversation.status else { return false }
                return selectedStatuses.contains(status)
            }
        }
        
        // Filter by label
        if !selectedLabels.isEmpty {
            filtered = filtered.filter { conversation in
                guard let label = conversation.label else { return false }
                return selectedLabels.contains(label)
            }
        }
        
        return filtered
    }
}

// MARK: - Extensions for Hashable

extension statusType: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    static func == (lhs: statusType, rhs: statusType) -> Bool {
        lhs.text == rhs.text
    }
}

extension LabelType: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    static func == (lhs: LabelType, rhs: LabelType) -> Bool {
        lhs.text == rhs.text
    }
}

// MARK: - Extensions for CaseIterable

extension statusType: CaseIterable {
    static var allCases: [statusType] = [.pending, .open, .resolved]
}

extension LabelType: CaseIterable {
    static var allCases: [LabelType] = [.warranty, .service, .payment, .maintenance, .spareparts]
}
