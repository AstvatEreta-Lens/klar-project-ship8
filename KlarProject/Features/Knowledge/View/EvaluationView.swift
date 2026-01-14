//
//  EvaluationView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 11/11/25.
//

import SwiftUI

struct EvaluationView: View {
    @ObservedObject var viewModel : ConversationListViewModel
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment : .leading){
                Divider()
                    .foregroundColor(Color.primaryText)
                
                SearchBar(
                    text: $viewModel.searchText,
                    onSearch: {
                        viewModel.loadConversations() // ganti le
                    }
                )
                .padding()
                
                HStack{
                    Text("Uploaded Files")
                        .padding(.leading, 14)
                        .foregroundColor(Color.textRegular)
                    
                    ZStack {
                        Circle()
                            .fill(Color.sectionHeader)
                            .frame(width: 16, height: 16)
                        
                        Text("\(viewModel.unreadCount)") // nanti ganti
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                // Three evaluation sections (rows)
                VStack(spacing: 10) {
                    evaluationRow(title: "Clarity", count: viewModel.unreadCount)
                    evaluationRow(title: "Accuracy", count: max(0, viewModel.unreadCount - 1))
                    evaluationRow(title: "Tone", count: max(0, viewModel.unreadCount - 2))
                }
                .padding(.horizontal, 14)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    EvaluationView(viewModel: ConversationListViewModel())
}

// MARK: - Components
private extension EvaluationView {
    func evaluationRow(title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .foregroundColor(Color.primaryText)
            Spacer()
            ZStack {
                Capsule()
                    .fill(Color.sectionHeader)
                    .frame(height: 22)
                Text("\(count)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
            }
        }
        .padding(12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}
#Preview {
    EvaluationView(viewModel: ConversationListViewModel())
}
