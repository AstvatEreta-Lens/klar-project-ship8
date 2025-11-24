//
//  StatisticsView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 24/11/25.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    var body: some View {
        Chart{
            ForEach(resolvedData){ ResolvedAIChat in
                AreaMark(
                        x: .value("Shape Type", ResolvedAIChat.day),
                        y: .value("Count", ResolvedAIChat.count)
                )
                .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.sectionHeader.opacity(0.25),
                                Color.sectionHeader.opacity(0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                
                LineMark(
                    x: .value("Shape Type", ResolvedAIChat.day),
                    y: .value("Count", ResolvedAIChat.count)
                )
                .foregroundStyle(Color.sectionHeader)
            }
            .annotation(position : .top){
                Text("Resolved Chat by AI")
                    .padding(.leading)
                    .font(.title)
                    .foregroundColor(Color.textRegular)
            }
        }
        .chartYScale(domain: 0...600)
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisValueLabel()
                    .foregroundStyle(Color.textRegular)
            }
        }
        .padding(.bottom)
        
        
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.white)
    .cornerRadius(18)
    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    StatisticsView()
        .frame(width : 947)
        .padding()
}


struct ResolvedAIChat : Identifiable{
    var day :  String
    var count : Double
    var id = UUID()
}

var resolvedData: [ResolvedAIChat] = [
    .init(day: "Sun", count: 50),
    .init(day: "Mon", count: 175),
    .init(day: "Tue", count: 150),
    .init(day: "Wed", count: 175),
    .init(day: "Thu", count: 275),
    .init(day: "Fri", count: 250),
    .init(day: "Sat", count: 500)
]
