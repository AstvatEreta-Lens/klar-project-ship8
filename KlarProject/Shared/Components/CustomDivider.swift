//
//  Divider.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 29/10/25.
//

import SwiftUI

struct CustomDivider : View {
    var body: some View {
        Rectangle()
            .fill(Color.borderColor)
            .frame(width : 307, height : 1)
            .padding(.top, 17)
            .padding(.bottom, 13)
            .padding(.leading, 16)
            .padding(.trailing, 16)
    }
}

#Preview {
    CustomDivider()
        .padding(10)
}
