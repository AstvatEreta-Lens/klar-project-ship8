//
//  dump.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/11/25.
//

import SwiftUI

struct dump: View {
    @State private var text : String = "Miaomiaoniga"
    @State private var nameText : String = "Pak Daud"
    
    var body: some View {
        VStack{
            EditableTextBox(text : $text)
            EditableTextBox(text : $nameText)
        }
    }
}

#Preview {
    dump()
}
