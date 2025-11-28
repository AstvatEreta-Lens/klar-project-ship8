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
    var onEnter: (() -> Void)? = nil
    
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as! NSTextView
        
        // Configure text view
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 17)
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.wantsLayer = true
        textView.layer?.cornerRadius = 8
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

        func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector)-> Bool {
             // Handle Enter key press
             if commandSelector == #selector(NSResponder.insertNewline(_:)) {
                 // Check if Shift key is pressed
                 let isShiftPressed = NSEvent.modifierFlags.contains(.shift)

                 if isShiftPressed {
                     // Shift+Return: Insert new line (allow default behavior)
                     return false
                 } else {
                     // Return alone: Send message
                     parent.onEnter?()
                     return true
                 }
             }
             return false
         }
    }
}
