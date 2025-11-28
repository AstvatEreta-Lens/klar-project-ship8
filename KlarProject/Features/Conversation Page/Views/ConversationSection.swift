//
//  ConversationSection.swift
//  KlarProject
//
// Created by Nicholas Tristandi on 05/11/25.

import SwiftUI


struct ConversationSection<Content: View>: View {
    let title: String
    let content: Content
    var count : Int?
    var viewModel : ConversationListViewModel?
    
    init(
        title: String,
        count : Int? = nil,
        viewModel : ConversationListViewModel? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.count = count
        self.viewModel = viewModel
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Section Header
            SectionHeader(title: title, count : count, viewModel: viewModel)
//                .font(.title2)
                    
            // Content with frame
            content
                .background(Color.backgroundPrimary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.borderColor, lineWidth: 1)
                )
                .padding(.top, -8) // Slight overlap with header border
        }
    }
}

#Preview {
    ConversationSection(title: "HANDLED BY HUMAN AGENTS") {
        ScrollView {
            VStack(spacing: 6) {
                ForEach(0..<5) { index in
                    Text("Conversation \(index + 1)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(8)
        }
        .frame(height: 315)
    }
    .padding()
}
