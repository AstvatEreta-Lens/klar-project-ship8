//
//  StatisticsView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 24/11/25.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @State private var selectedPoint: ResolvedAIChat?
    @State private var selectedReferenceId: String?
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Resolved Chat by AI")
                .font(.title)
                .foregroundColor(Color.textRegular)
                .padding(.leading)

            Chart {
                ForEach(resolvedData) { item in
                    let xValue = item.day
                    let yValue = item.count

                    AreaMark(
                        x: .value("Day", xValue),
                        y: .value("Count", yValue)
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
                        x: .value("Day", xValue),
                        y: .value("Count", yValue)
                    )
                    .symbol {
                        CustomSymbol(count: Int(yValue), isSelected: selectedPoint?.referenceId == item.referenceId)
                    }
                    .foregroundStyle(Color.sectionHeader)
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
            .padding(.horizontal, -50)
            .chartXSelection(value: $selectedReferenceId)
            .onChange(of: selectedReferenceId) { oldValue, newValue in
                if let newValue = newValue {
                    selectedPoint = resolvedData.first(where: { $0.referenceId == newValue })
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top)
        .background(Color.dashboardCardColor)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    StatisticsView()
        .frame(width: 947)
        .padding()
}


struct ResolvedAIChat: Identifiable {
    var day: String
    var count: Double
    var referenceId: String { day }
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


private struct CustomSymbol: View {
    let count: Int
    let isSelected: Bool
    
    var body: some View {
        ZStack{
            if isSelected {
                TooltipView(text: "\(Int(count))")
                    .offset(y:-28)
            }
            
            Circle()
                .fill(isSelected ? Color.sectionHeader : Color.clear)
                .frame(width: isSelected ? 14 : 10, height: isSelected ? 14 : 10)
//                .overlay(
//                    Circle()
//                        .stroke(isSelected ? Color.white : Color.white.opacity(0.3), lineWidth: 1)
//                )
//                .shadow(color: Color.gray.opacity(0.7), radius: 8, x: 0, y: 2)
        }
    }
}


private struct TooltipView: View {
    let text: String
    
    init(text: String){
        self.text = text
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.sectionHeader)
                .frame(width : 36, height : 30)
                .cornerRadius(5)
                .overlay(alignment : .bottom){
                        Triangle()
                        .fill(Color.sectionHeader)
                        .frame(width : 20, height : 10)
                        .rotationEffect(Angle(degrees : 180))
                        .offset(y : 5)
                }
            
            Text(text)
                .font(.caption)
                .foregroundColor(Color.white)
//                .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 2)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}
