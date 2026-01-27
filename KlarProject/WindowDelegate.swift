//
//  WindowDelegate.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import SwiftUI
import AppKit

class WindowDelegate: NSObject, NSWindowDelegate, ObservableObject {
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        let minWidth : CGFloat = 1000
        let minHeight : CGFloat = 982
        
        return NSSize(
            width: max(frameSize.width, minWidth),
            height: max(frameSize.height, minHeight)
        )
    }
    
//    func 
}
