
//
//  StatisticsView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/11/25.
//
//
import SwiftUI
import Charts

struct StatisticsViewDump: View {
    var body: some View {
        Chart{
            ForEach(stackedBarData){ shape in
                BarMark(
                    x: .value("Shape Type", shape.type),
                    y: .value("Count", shape.count)
                )
                .foregroundStyle(by: .value("Count", shape.color))
            }
        }
    }
}

struct StatisticsView1Dump : View {
    var body: some View {
        Chart{
            ForEach(data){ shape in
                LineMark(
                    x: .value("Shape Type", shape.type),
                    y: .value("Count", shape.count)
                )
                .foregroundStyle(shape.color)
            }
        }
        
    }
}


struct ToyShape : Identifiable{
    var type :  String
    var count : Double
    var id = UUID()
    var color : Color
}

var data: [ToyShape] = [
    .init(type: "Car", count: 100, color : Color.red),
    .init(type: "Plane", count: 50, color : Color.yellow),
    .init(type: "Cat", count: 300, color : Color.blue)
]


struct ToyShape1: Identifiable{
    var color :  String
    var type : String
    var count : Double
    var id =  UUID()
}

var stackedBarData: [ToyShape1] = [
    .init(color: "Green", type: "Cube", count: 2),
    .init(color: "Green", type: "Sphere", count: 0),
    .init(color: "Green", type: "Pyramid", count: 1),
    .init(color: "Purple", type: "Cube", count: 1),
    .init(color: "Purple", type: "Sphere", count: 1),
    .init(color: "Purple", type: "Pyramid", count: 1),
    .init(color: "Pink", type: "Cube", count: 1),
    .init(color: "Pink", type: "Sphere", count: 2),
    .init(color: "Pink", type: "Pyramid", count: 0),
    .init(color: "Yellow", type: "Cube", count: 1),
    .init(color: "Yellow", type: "Sphere", count: 1),
    .init(color: "Yellow", type: "Pyramid", count: 2)
]


#Preview {
    StatisticsViewDump()
    StatisticsView1Dump()
        .padding()
}
