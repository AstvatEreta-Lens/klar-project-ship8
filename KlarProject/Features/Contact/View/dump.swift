//
//  dump.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/11/25.
//

import SwiftUI

struct dump: View {
    @State private var text : String = "Miaomiaoniga"
    
    var body: some View {
        EditableTextBox(text : $text)
    }
}

#Preview {
    dump()
}
