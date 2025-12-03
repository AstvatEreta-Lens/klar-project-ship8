
//
//  CustomSegmentPicker1.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 18/11/25.
//


import SwiftUI


struct CustomSegmentPicker1: View {
    @Binding var selectedTab: Int
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            SegmentButton(
                icon: "doc.fill",
                title: NSLocalizedString("Files", comment : ""),
                isSelected: selectedTab == 0,
                namespace: animation
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 0
                }
            }
            
            SegmentButton(
                icon: "doc.text.magnifyingglass",
                title: NSLocalizedString("Evaluation", comment : ""),
                isSelected: selectedTab == 1,
                namespace: animation
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 1
                }
            }
        }
        .background(Color(hex: "F5F5F5"))
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding(4)
        .background(Color(hex: "E6E6E6"))
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding(.bottom)
    }
}

struct SegmentButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? Color.white : Color.textRegular)
                    .font(.body)
                Text(title)
                    .foregroundColor(isSelected ? Color.white : Color.textRegular)
                    .font(.body)
            }
            .foregroundColor(isSelected ? .primary : .secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 3)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 11)
                        .fill(Color.sectionHeader)
                        .matchedGeometryEffect(id: "selectedSegment", in: namespace)
                        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview("Basic Usage") {
    VStack(spacing: 30) {
        CustomSegmentPicker1(selectedTab: .constant(0))
        CustomSegmentPicker1(selectedTab: .constant(1))
    }
    .padding()
    .frame(maxWidth: 290, maxHeight: 360)
    .background(Color(hex: "F5F5F5"))
}
