//
//  SectionHeader.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 22/10/25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(.black)
                    .tracking(0.5)
                    .padding(.horizontal, 14)
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 11)
            .background(Color.white)
            
            Divider()
                .background(Color.black)
        }
        .overlay(
            UnevenRoundedRectangle(
                topLeadingRadius: 12,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 12
            )
            .stroke(Color.black, lineWidth: 1)
            // Jarak antara handled by..... dengan list convo
            .padding(.bottom, 1)
        )
    }
}

#Preview {
    VStack(spacing : 10){
        SectionHeader(title: "Handled By Human Agents")
        SectionHeader(title: "Handled By AI")
    }
    .padding(10)
}
