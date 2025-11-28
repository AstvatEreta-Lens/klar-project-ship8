//
//  dump.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/11/25.
//


//import SwiftUI
//import Charts
//
//struct ChartData: Identifiable {
//    let id = UUID()
//    let referenceId: String
//    let date: String
//    let value: Double
//
//    // Sample Data
//    static func mockData() -> [ChartData] {
//        return [
//            ChartData(referenceId: "Session1", date: "1 Jun", value: 10.0),
//            ChartData(referenceId: "Session2", date: "4 Jun", value: 85.0),
//            ChartData(referenceId: "Session3", date: "7 Jun", value: 65.0),
//            ChartData(referenceId: "Session4", date: "10 Jun", value: 90.0),
//            ChartData(referenceId: "Session5", date: "14 Jun", value: 70.0),
//            ChartData(referenceId: "Session6", date: "18 Jun", value: 25.0),
//            ChartData(referenceId: "Session7", date: "21 Jun", value: 80.0),
//            ChartData(referenceId: "Session8", date: "24 Jun", value: 20.0),
//            ChartData(referenceId: "Session9", date: "27 Jun", value: 100.0),
//            ChartData(referenceId: "Session10", date: "30 Jun", value: 68.0),
//            ChartData(referenceId: "Session11", date: "3 Jul", value: 42.0),
//            ChartData(referenceId: "Session12", date: "6 Jul", value: 95.0),
//            ChartData(referenceId: "Session13", date: "9 Jul", value: 50.0)
//        ]
//    }
//}
//
//struct ChartView: View {
//    let chartData = ChartData.mockData()
//    @State private var selectedDataPoint: ChartData?
//    @State private var selectedReferenceId: String?
//
//    private var bgGradient: LinearGradient {
//        LinearGradient(
//            colors: [Color.sectionHeader.opacity(0.95), Color.sectionHeader.opacity(0.7)],
//            startPoint: .topLeading,
//            endPoint: .bottomTrailing
//        )
//    }
//
//    var body: some View {
//        ZStack {
//            bgGradient.ignoresSafeArea()
//            ChartContent(
//                chartData: chartData,
//                selectedDataPoint: $selectedDataPoint,
//                selectedReferenceId: $selectedReferenceId
//            )
//        }
//    }
//}
//
//private struct ChartContent: View {
//    let chartData: [ChartData]
//    @Binding var selectedDataPoint: ChartData?
//    @Binding var selectedReferenceId: String?
//
//    private let lineStyle: StrokeStyle = .init(lineWidth: 4, lineCap: .round, lineJoin: .round)
//    private let lineColor: Color = Color.sectionHeader
//
//    var body: some View {
//        Chart(chartData) { dataPoint in
//            ChartLineMark(
//                dataPoint: dataPoint,
//                isSelected: selectedDataPoint?.referenceId == dataPoint.referenceId,
//                lineStyle: lineStyle,
//                lineColor: lineColor
//            )
//        }
//        .chartXAxis {
//            AxisMarks(values: .automatic(desiredCount: 6)) { axisValue in
//                if let ref = axisValue.as(String.self),
//                   let dataPoint = chartData.first(where: { $0.referenceId == ref }) {
//                    let components = dataPoint.date.split(separator: " ")
//                    AxisValueLabel {
//                        VStack {
//                            Text(String(components.first ?? ""))
//                            Text(String(components.last ?? ""))
//                        }
//                        .font(.system(size: 12))
//                        .foregroundStyle(.white)
//                    }
//                } else {
//                    AxisValueLabel("")
//                }
//                AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1, dash: [5]))
//                    .frame(height: 300)
//                    .foregroundStyle(.white.opacity(0.2))
//            }
//        }
//        .chartYAxis {
//            AxisMarks(position: .leading, values: [0.0, 20.0, 40.0, 60.0, 80.0, 100.0]) { axisValue in
//                let intValue: Int = Int(axisValue.as(Double.self) ?? 0)
//                AxisValueLabel { Text("\(intValue)") }
//                    .foregroundStyle(.white.opacity(0.6))
//                    .font(.system(size: 12))
//            }
//        }
//        .chartXSelection(value: $selectedReferenceId)
//        .onChange(of: selectedReferenceId) { _, newValue in
//            guard let newValue else { return }
//            selectedDataPoint = chartData.first(where: { $0.referenceId == newValue })
//        }
//        .chartYScale(domain: [-10, 110])
//        .chartScrollableAxes(.horizontal)
//        .chartXVisibleDomain(length: 6)
//        .frame(height: 320)
//    }
//}
//
//private struct ChartLineMark: View {
//    let dataPoint: ChartData
//    let isSelected: Bool
//    let lineStyle: StrokeStyle
//    let lineColor: Color
//
//    var body: some View {
//        LineMark(
//            x: .value("referenceId", dataPoint.referenceId),
//            y: .value("progress", dataPoint.value)
//        )
//        .symbol { CustomSymbol(value: dataPoint.value, isSelected: isSelected) }
//        .lineStyle(lineStyle)
//        .foregroundStyle(lineColor)
//    }
//}
//
//private struct CustomSymbol: View {
//
//    private func color(for value: Double) -> Color {
//        switch value {
//        case 0..<35:
//            return .red.opacity(0.85)
//        case 35..<70:
//            return .yellow.opacity(0.85)
//        case 70...100:
//            return .green.opacity(0.85)
//        default:
//            return .gray.opacity(0.7)
//        }
//    }
//
//    let value: Double
//    let isSelected: Bool
//
//    var body: some View {
//        ZStack {
//            if isSelected {
//                TooltipView(text: "\(Int(value))")
//                    .offset(y: value > 88 ? 28 : -28)
//            }
//
//            let fillGradient = RadialGradient(
//                gradient: Gradient(colors: [color(for: value), color(for: value).opacity(0.5)]),
//                center: .center,
//                startRadius: 3,
//                endRadius: 8
//            )
//            Circle()
//                .fill(fillGradient)
//                .frame(width: isSelected ? 14.0 : 10.0, height: isSelected ? 14.0 : 10.0)
//                .overlay(
//                    Circle()
//                        .stroke(isSelected ? Color.white : Color.white.opacity(0.3), lineWidth: isSelected ? 3 : 2)
//                )
//                .shadow(color: color(for: value).opacity(0.7), radius: 8, x: 0, y: 2)
//        }
//    }
//}
//
//private struct TooltipView: View {
//
//    let text: String
//
//    init(text: String) {
//        self.text = text
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            ZStack {
//                let tooltipGradient = LinearGradient(
//                    gradient: Gradient(colors: [Color.white, Color.sectionHeader]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//                RoundedRectangle(cornerRadius: 12, style: .continuous)
//                    .fill(tooltipGradient)
//                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
//                    .frame(width: 46, height: 33)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 12, style: .continuous)
//                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
//                    )
//                    .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 3)
//
//                Text(text)
//                    .font(.system(size: 16, weight: .semibold, design: .rounded))
//                    .foregroundColor(.white)
//                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
//            }
//        }
//    }
//}
//
//#Preview{
//    ChartView()
//        .padding()
//}
