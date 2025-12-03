//
//  SectionHeader.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 22/10/25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var count: Int?
    var viewModel: ConversationListViewModel?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.callout)
                    .foregroundColor(Color.tertiaryText)
                    .padding(.leading, 14)
                
                ZStack{
                    Circle()
                        .fill(Color.tertiaryText)
                        .frame(width: 14, height: 12)
                    if let count = count {
                        Text("\(count)")
                            .foregroundColor(Color.sectionHeader)
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                }
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 15)
            
            .background(
                Color.sectionHeader
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 12,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 12
                        )
                    )
            )
            .overlay(
                UnevenRoundedRectangle(
                    topLeadingRadius: 12,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 12
                )
                .stroke(Color.borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    VStack(spacing : 10){
        SectionHeader(title: "HANDLED BY HUMAN AGENTS")
        SectionHeader(title: "HANDLED BY AI")
    }
    .padding(10)
}
