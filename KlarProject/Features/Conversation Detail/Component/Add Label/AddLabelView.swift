//
//  AddLabelView_MultiLabel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 06/11/25.
//

import SwiftUI

// MARK: - Add Label View (Multi-Label Support)

struct AddLabelView: View {
    @ObservedObject var viewModel: AddLabelViewModel
    @Environment(\.dismiss) var dismiss
    
    var onAddLabels: ([LabelType]) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with title
            HStack {
                Text("Add labels")
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Label")
                    .font(.caption)
                    .foregroundColor(.primary)
                
                // Display selected labels (Chunked jadi 3 baris)
                if !viewModel.selectedLabels.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(viewModel.selectedLabels).chunked(into: 3), id: \.first!.text) { chunk in
                            HStack(spacing: 8) {
                                ForEach(chunk, id: \.text) { label in
                                    SelectedLabelChip(
                                        label: label,
                                        onRemove: {
                                            viewModel.toggleLabel(label)
                                        }
                                    )
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Available Labels Grid
                VStack(spacing: 11) {
                    // Row 1: Service, Warranty, Sparepart
                    HStack(spacing: 11) {
                        AddLabelButton(
                            label: .service,
                            isSelected: viewModel.isLabelSelected(.service),
                            action: {
                                viewModel.toggleLabel(.service)
                            }
                        )
                        
                        AddLabelButton(
                            label: .warranty,
                            isSelected: viewModel.isLabelSelected(.warranty),
                            action: {
                                viewModel.toggleLabel(.warranty)
                            }
                        )
                        
                        AddLabelButton(
                            label: .spareparts,
                            isSelected: viewModel.isLabelSelected(.spareparts),
                            action: {
                                viewModel.toggleLabel(.spareparts)
                            }
                        )
                    }
                    
                    // Row 2: Payment, Maintenance
                    HStack(spacing: 11) {
                        AddLabelButton(
                            label: .payment,
                            isSelected: viewModel.isLabelSelected(.payment),
                            action: {
                                viewModel.toggleLabel(.payment)
                            }
                        )
                        
                        AddLabelButton(
                            label: .maintenance,
                            isSelected: viewModel.isLabelSelected(.maintenance),
                            action: {
                                viewModel.toggleLabel(.maintenance)
                            }
                        )
                        
                        Spacer()
                    }
                }
            }
            
            Spacer()
            
            // Add Button
            AddLabelsButton(
                isEnabled: !viewModel.selectedLabels.isEmpty,
                action: {
                    onAddLabels(Array(viewModel.selectedLabels))
                    dismiss()
                }
            )
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
        .frame(minWidth: 350, maxWidth: .infinity, maxHeight: 400, alignment: .top)
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Supporting Components

struct SelectedLabelChip: View {
    let label: LabelType
    let onRemove: () -> Void
    
    var body: some View {
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

struct AddLabelButton: View {
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

struct AddLabelsButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .frame(height: 36)
                    .foregroundColor(isEnabled ? Color.sectionHeader : Color.gray)
                    .cornerRadius(11)
                
                Text("Add")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Previews

#Preview("No Labels Selected") {
    AddLabelView(
        viewModel: AddLabelViewModel(),
        onAddLabels: { labels in
            print("Add labels tapped: \(labels)")
        }
    )
    .frame(width: 350)
}

#Preview("With 2 Labels Selected") {
    let viewModel = AddLabelViewModel(existingLabels: [.service, .warranty])
    
    return AddLabelView(
        viewModel: viewModel,
        onAddLabels: { labels in
            print("Add labels tapped: \(labels)")
        }
    )
    .frame(width: 350)
}

#Preview("With 3+ Labels Selected") {
    let viewModel = AddLabelViewModel(existingLabels: [.service, .warranty, .payment])
    
    return AddLabelView(
        viewModel: viewModel,
        onAddLabels: { labels in
            print("Add labels tapped: \(labels)")
        }
    )
    .frame(width: 350)
}

#Preview("All Labels Selected") {
    let viewModel = AddLabelViewModel()
    viewModel.selectedLabels = Set(LabelType.allCases)
    
    return AddLabelView(
        viewModel: viewModel,
        onAddLabels: { labels in
            print("Add labels tapped: \(labels)")
        }
    )
    .frame(width: 350)
}
