//
//  ConversationLabels.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 24/11/25.
//

import SwiftUI

struct ConversationLabels: View {
    @State private var uniqueRandomNumber: [LabelType: Int] = [:]
    
    let label : LabelType
    let rangeStart = 1
    let rangeEnd = 100
    
    var body: some View {
        VStack(alignment : .leading){
            Text("Top Issues")
                .foregroundColor(Color.textRegular)
                .fontWeight(.bold)
                .font(.title2)
                .padding(.vertical, 10)
            
            ForEach(LabelType.allCases, id: \.self) { labelType in
                HStack{
                    Text(labelType.text)
                        .foregroundColor(Color.textRegular)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            Color.gray.opacity(0.2)
                        )
                        .cornerRadius(3)
                    
                    Spacer()
                    if let number = uniqueRandomNumber[labelType] {
                        Text("\(number)")
                            .font(.caption)
                            .foregroundColor(Color.grayTextColor)
                    } else {
                        Text("N/A")
                    }
                }
            }
        .padding(.vertical, 1)
            Spacer()
        }
        .onAppear(perform: generateNumber)
        .padding()
        .background(Color.dashboardCardColor)
        .cornerRadius(11)
        .frame(maxWidth : .infinity, maxHeight : .infinity)
//        .overlay(
//            RoundedRectangle(cornerRadius: 11)
//                .stroke(Color.sectionHeader.opacity(0.5), lineWidth: 1.2)
//        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
    private func generateNumber(){
        guard uniqueRandomNumber.isEmpty else { return }
        
        for labelType in LabelType.allCases {
            let newRandomNumber = Int.random(in: rangeStart...rangeEnd)
            
            uniqueRandomNumber[labelType] = newRandomNumber
        }
    }
}






#Preview {
    ConversationLabels(label : .warranty)
        .padding()
}
