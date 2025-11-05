//
//  AdaptableTextFieldHeight.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 05/11/25.
//

import SwiftUI
import AppKit

struct MacOSTextEditor: NSViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let placeholder: String = "Type your text"
    
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as! NSTextView
        
        // Configure text view
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .labelColor
        textView.backgroundColor = .clear
        textView.isRichText = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = true
        textView.textContainerInset = NSSize(width : 8, height : 10)
        
        // Configure scroll view
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        
        return scrollView
    }
    
    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        
        if textView.string != text {
            textView.string = text
        }
        
        // Update height based on content
        let contentHeight = textView.layoutManager?
            .usedRect(for: textView.textContainer!)
            .height ?? minHeight
        
        let newHeight = max(minHeight, min(contentHeight + 16, maxHeight))
        
        if abs(height - newHeight) > 1 {
            DispatchQueue.main.async {
                height = newHeight
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MacOSTextEditor
        
        init(_ parent: MacOSTextEditor) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
    }
}
