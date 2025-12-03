//
//  OnHoverText.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 11/11/25.
//
import SwiftUI

struct HoverBubbleView: View {
    @State private var isHovered = false

    var body: some View {
        VStack {
            Button(action: {}) {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hovering
                }
            }
            .overlay(alignment: .topLeading) {
                if isHovered {
                    BubbleTooltip(text: "Ini adalah informasi tambahan yang muncul saat hover.")
                        .fixedSize(horizontal: false, vertical: true)
                        .offset(x: 30, y: -10)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .padding(50)
    }
}

struct BubbleTooltip: View {
    let text: String

    var body: some View {
        VStack(spacing: 0) {
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.5))
                        .shadow(radius: 4)
                )

            TrianglePointer()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 12, height: 7)
                .offset(y: -1)
        }
        .fixedSize() // biar ukuran disesuaikan dengan teks penuh
    }
}

struct TrianglePointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    HoverBubbleView()
}
