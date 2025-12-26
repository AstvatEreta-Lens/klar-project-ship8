//
//  HighlightedText.swift
//  KlarProject
//
//  Created by Claude Code
//

import SwiftUI

struct HighlightedText: View {
    let text: String
    let searchText: String
    let highlightColor: Color

    init(text: String, searchText: String, highlightColor: Color = Color.yellow.opacity(0.5)) {
        self.text = text
        self.searchText = searchText
        self.highlightColor = highlightColor
    }

    var body: some View {
        if searchText.isEmpty {
            Text(text)
                .foregroundColor(Color(hex: "#3E3E3E"))
        } else {
            Text(attributedString)
                .foregroundColor(Color(hex: "#3E3E3E"))
        }
    }

    private var attributedString: AttributedString {
        var attributedString = AttributedString(text)
        let ranges = text.ranges(of: searchText, options: .caseInsensitive)

        // Apply highlighting to matched ranges
        for range in ranges {
            // Convert String.Index range to AttributedString.Index range
            let lowerBound = AttributedString.Index(range.lowerBound, within: attributedString)!
            let upperBound = AttributedString.Index(range.upperBound, within: attributedString)!
            let attributedRange = lowerBound..<upperBound

            // Apply bold and background color to matched text
            attributedString[attributedRange].font = .body.bold()
            attributedString[attributedRange].backgroundColor = highlightColor
        }

        return attributedString
    }
}

// Extension to find all ranges of a substring
extension String {
    func ranges(of searchString: String, options: String.CompareOptions = []) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var startIndex = self.startIndex

        while startIndex < self.endIndex,
              let range = self.range(of: searchString, options: options, range: startIndex..<self.endIndex) {
            ranges.append(range)
            startIndex = range.upperBound
        }

        return ranges
    }
}

#Preview {
    VStack(spacing: 20) {
        HighlightedText(
            text: "Hello world, this is a test message",
            searchText: "test"
        )

        HighlightedText(
            text: "The quick brown fox jumps over the lazy dog",
            searchText: "the"
        )

        HighlightedText(
            text: "No match here",
            searchText: "xyz"
        )
    }
    .padding()
}
