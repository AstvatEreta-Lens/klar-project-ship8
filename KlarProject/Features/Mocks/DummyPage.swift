//
//  DummyPage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 21/10/25.
//

import SwiftUI

struct DummyPage: View {
    var body: some View {
        VStack{
            Image("Pak Lu Hoot")
                .frame(width : 628, height : 902)
            
            Button(action: {
                print("Filter Button Clicked")
            }) {
                Text("Take Over")
                    .foregroundColor(.black)
                    .cornerRadius(0)
            }
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    DummyPage()
}
