//
//  PickerStyle.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import SwiftUI

struct PickerStyle : ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.black)
            .cornerRadius(10)
    }
}

extension View {
    func pickerStyle() -> some View {
        modifier(PickerStyle())
    }
}
