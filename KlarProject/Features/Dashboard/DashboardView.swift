//
//  DashboardView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

struct DashboardView: View {
    
    var body: some View {
        GeometryReader { geometry in

            VStack{
                Text("uhuk")
                    .foregroundColor(Color.white)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 11)
                    .stroke(Color.sectionHeader, lineWidth: 1)
            )
        }
    }
}

#Preview {
    DashboardView()
        .padding()
}
