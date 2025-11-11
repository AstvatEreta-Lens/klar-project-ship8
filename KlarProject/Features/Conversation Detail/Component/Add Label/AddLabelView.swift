//
//  AddLabelView_MultiLabel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 06/11/25.
//

import SwiftUI

// MARK: - Add Label View (Same Style as FilterView)

struct AddLabelView: View {
    @ObservedObject var viewModel: AddLabelViewModel
    @Environment(\.dismiss) var dismiss
    
    var onLabelToggle: (LabelType) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with title
            HStack {
                Text("Add labels")
                    .font(.caption)
                    .foregroundColor(Color.textRegular)
                
                Spacer()
            }
            .padding(.top, 16)
            
            VStack(spacing: 11) {
                // Row 1: Service, Warranty, Payment
                HStack(spacing: 11) {
                    LabelFilterButton(
                        label: .service,
                        isSelected: viewModel.isLabelSelected(.service),
                        action: {
                            viewModel.toggleLabel(.service)
                            onLabelToggle(.service)
                        }
                    )
                    .padding(.leading, -25)
                    
                    LabelFilterButton(
                        label: .warranty,
                        isSelected: viewModel.isLabelSelected(.warranty),
                        action: {
                            viewModel.toggleLabel(.warranty)
                            onLabelToggle(.warranty)
                        }
                    )
                    
                    LabelFilterButton(
                        label: .payment,
                        isSelected: viewModel.isLabelSelected(.payment),
                        action: {
                            viewModel.toggleLabel(.payment)
                            onLabelToggle(.payment)
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
                            onLabelToggle(.maintenance)
                        }
                    )
                    
                    LabelFilterButton(
                        label: .spareparts,
                        isSelected: viewModel.isLabelSelected(.spareparts),
                        action: {
                            viewModel.toggleLabel(.spareparts)
                            onLabelToggle(.spareparts)
                        }
                    )
                    
                    Spacer()
                }
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 20)
        .frame(width: 280)  // Adjust width sesuai kebutuhan
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Previews

#Preview("No Labels Selected") {
    AddLabelView(
        viewModel: AddLabelViewModel(),
        onLabelToggle: { label in
            print("Label toggled: \(label.text)")
        }
    )
    .padding()
}

#Preview("With Labels Selected") {
    let viewModel = AddLabelViewModel(existingLabels: [.service, .warranty])
    
    return AddLabelView(
        viewModel: viewModel,
        onLabelToggle: { label in
            print("Label toggled: \(label.text)")
        }
    )
    .padding()
}

#Preview("With Multiple Labels") {
    let viewModel = AddLabelViewModel(existingLabels: [.service, .warranty, .payment])
    
    return AddLabelView(
        viewModel: viewModel,
        onLabelToggle: { label in
            print("Label toggled: \(label.text)")
        }
    )
    .padding()
}

#Preview("All Labels Selected") {
    let viewModel = AddLabelViewModel(existingLabels: [.service, .warranty, .payment, .maintenance, .spareparts])
    
    return AddLabelView(
        viewModel: viewModel,
        onLabelToggle: { label in
            print("Label toggled: \(label.text)")
        }
    )
    .padding()
}
