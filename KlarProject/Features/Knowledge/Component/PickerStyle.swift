//
//  PickerStyle.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import SwiftUI

private struct SegmentFramePreferenceKey: PreferenceKey {
  static var defaultValue: [CGRect] = []
  static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
    value.append(contentsOf: nextValue())
  }
}

struct CustomSegmentedPickerView: View {
  @Binding var selectedIndex: Int 
  private let titles: [String] = ["Files", "Evaluation"]
  private let colors: [Color] = [Color(hex: "#E6E6E6"), Color(hex: "#E6E6E6")]
  @State private var frames: [CGRect] = Array(repeating: .zero, count: 2)

  var body: some View {
    VStack {
      ZStack(alignment: .leading) {
        // Moving capsule background
        if frames.indices.contains(selectedIndex) {
          Capsule()
            .fill(colors[selectedIndex].opacity(0.4))
            .frame(width: frames[selectedIndex].width, height: frames[selectedIndex].height)
            .offset(x: offsetXForSelected(), y: 0)
        }

        HStack(spacing: 0) {
          ForEach(titles.indices, id: \.self) { index in
            segmentButton(title: titles[index], index: index)
              .background(
                GeometryReader { geo in
                  Color.clear
                    .preference(key: SegmentFramePreferenceKey.self, value: [geo.frame(in: .named("SEGMENT"))])
                }
              )
          }
        }
      }
      .coordinateSpace(name: "SEGMENT")
      .background(Capsule().stroke(Color.gray, lineWidth: 1))
      .onPreferenceChange(SegmentFramePreferenceKey.self) { values in
        // Ensure we only keep as many frames as there are titles
        var newFrames = Array(values.prefix(titles.count))
        if newFrames.count < titles.count {
          newFrames.append(contentsOf: Array(repeating: .zero, count: titles.count - newFrames.count))
        }
        frames = newFrames
      }
    }
    .padding(.vertical, 4)
  }

  @ViewBuilder
  private func segmentButton(title: String, index: Int) -> some View {
    Button(action: { selectedIndex = index }) {
      Text(title)
        .foregroundColor(Color.textRegular)
        .frame(maxWidth: 169)
        .padding(.vertical, 10)
        
//        .padding(.horizontal, 12)
    }
    .buttonStyle(.plain)
  }

  private func offsetXForSelected() -> CGFloat {
    guard frames.indices.contains(selectedIndex), frames.indices.contains(0) else { return 0 }
    return frames[selectedIndex].minX - frames[0].minX
  }
}

//struct CustomSegmentedPickerView_Previews: PreviewProvider {
//  static var previews: some View {
//    CustomSegmentedPickerView()
//      .padding()
//      
//  }
//}
