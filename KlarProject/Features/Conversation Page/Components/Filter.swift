//
//  FilterView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//  Updated: 04/11/25 - Manual layout (most reliable)
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: FilterViewModel
    @Environment(\.dismiss) var dismiss
    
    var onApplyFilter: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Filter Applied")
                    .font(.caption)
            }
            .padding(.top, 26)
            
            // Active Filters Section
            VStack(alignment: .leading){
                if viewModel.hasActiveFilters {
                    // Manual wrapping for active filters
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.activeFilters.chunked(into: 3), id: \.first!.id) { chunk in
                            HStack(spacing: 8) {
                                ForEach(chunk) { filter in
                                    ActiveFilterChip(
                                        filter: filter,
                                        onRemove: {
                                                viewModel.removeFilter(filter)
                                        }
                                    )
                                }
                                Spacer()
                            }
                        }
                    }
                } else {
                    // Empty state
                    Text("No active filters, choose below.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 4)
            
            
            // Status Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Status")
                    .font(.caption)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    ForEach(statusType.allCases, id: \.text) { status in
                        StatusFilterButton(
                            status: status,
                            isSelected: viewModel.isStatusSelected(status),
                            action: {
                                    viewModel.toggleStatus(status)
                            }
                        )
                    }
                }
            }
            
            // Label Section - Manual layout (2 per row)
            VStack(alignment: .leading, spacing: 12) {
                Text("Label")
                    .font(.caption)
                    .foregroundColor(.primary)
                
                VStack(spacing: 11) {
                    // Row 1: Service, Warranty, Payment
                    HStack(spacing: 11) {
                        LabelFilterButton(
                            label: .service,
                            isSelected: viewModel.isLabelSelected(.service),
                            action: {
                                    viewModel.toggleLabel(.service)
                            }
                        )
                        .padding(.leading, -40)
                        
                        LabelFilterButton(
                            label: .warranty,
                            isSelected: viewModel.isLabelSelected(.warranty),
                            action: {
                                    viewModel.toggleLabel(.warranty)
                            }
                        )
                        
                        LabelFilterButton(
                            label: .payment,
                            isSelected: viewModel.isLabelSelected(.payment),
                            action: {
                                    viewModel.toggleLabel(.payment)
                            }
                        )
                    }
                    
                    // Row 2: Maintenance, Spareparts
                    HStack(spacing: 11) {
                        LabelFilterButton(
                            label: .maintenance,
                            isSelected: viewModel.isLabelSelected(.maintenance),
                            action: {
                                    viewModel.toggleLabel(.maintenance)
                            }
                        )
                        
                        LabelFilterButton(
                            label: .spareparts,
                            isSelected: viewModel.isLabelSelected(.spareparts),
                            action: {
                                    viewModel.toggleLabel(.spareparts)
                            }
                        )
                        
                        Spacer()
                    }
                }
            }
            
            Spacer()
            
            // Apply Filter Button
            ApplyFilterButton(
                isEnabled: viewModel.hasActiveFilters,
                action: {
                    onApplyFilter()
                    dismiss()
                }
            )
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
        .frame(minWidth: 307, maxWidth: .infinity, maxHeight: 330, alignment: .top)
        .background(Color.white)
    }
}

// MARK: - Array Extension for Chunking

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

// MARK: - Active Filter Chip

struct ActiveFilterChip: View {
    let filter: ActiveFilter
    let onRemove: () -> Void
    
    var body: some View {
        Group {
            if filter.type == .status, let status = filter.statusValue {
                HStack(spacing: 4) {
                    ZStack {
                        Rectangle()
                            .fill(status.color)
                            .frame(height: 18)
                            .cornerRadius(11)
                        
                        HStack(spacing: 4) {
                            Text(status.text)
                                .foregroundColor(status.colorText)
                                .font(.caption)
                                .fontWeight(.light)
                            
                            Button(action: onRemove) {
                                Image(systemName: "xmark")
                                    .foregroundColor(status.colorText)
                                    .font(.system(size: 10))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 12)
                    }
                }
                .fixedSize()
                
            } else if filter.type == .label, let label = filter.labelValue {
                HStack(spacing: 4) {
                    Text(label.text)
                        .foregroundColor(Color.labelBorderColor)
                        .font(.caption)
                    
                    Button(action: onRemove) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.labelBorderColor)
                            .font(.caption)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 8)
                .frame(height: 18)
                .background(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.labelBorderColor, lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white)
                        )
                )
                .fixedSize()
            }
        }
    }
}

// MARK: - Status Filter Button

struct StatusFilterButton: View {
    let status: statusType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(isSelected ? status.color : Color.clear)
                    .frame(width: 61.19, height: 18)
                    .cornerRadius(11)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(status.color, lineWidth: 1)
                    )
                
                Text(status.text)
                    .foregroundColor(isSelected ? status.colorText : status.color)
                    .font(.subheadline)
                    .fontWeight(.regular)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Label Filter Button

struct LabelFilterButton: View {
    let label: LabelType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label.text)
                .foregroundColor(Color.labelBorderColor)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color.gray.opacity(0.2) : Color.gray.opacity(0.05)
                )
                .cornerRadius(3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Apply Filter Button

struct ApplyFilterButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .frame(height: 36)
                    .foregroundColor(isEnabled ? Color.sectionHeader : Color.gray)
                    .cornerRadius(11)
                
                Text("Apply Filter")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(isEnabled ? Color.white : Color.white)
            }
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Previews

#Preview("No Filters") {
    FilterView(
        viewModel: FilterViewModel(),
        onApplyFilter: {
            print("Apply filter tapped")
        }
    )
    .frame(width: 307)
}

#Preview("With Filters") {
    let viewModel = FilterViewModel()
    viewModel.selectedStatuses = [.pending, .open]
    viewModel.selectedLabels = [.service]
    
    return FilterView(
        viewModel: viewModel,
        onApplyFilter: {
            print("Apply filter tapped")
        }
    )
    .frame(width: 307)
}

#Preview("All Filters") {
    let viewModel = FilterViewModel()
    viewModel.selectedStatuses = Set(statusType.allCases)
    viewModel.selectedLabels = Set(LabelType.allCases)
    
    return FilterView(
        viewModel: viewModel,
        onApplyFilter: {
            print("Apply filter tapped")
        }
    )
    .frame(width: 307)
}
