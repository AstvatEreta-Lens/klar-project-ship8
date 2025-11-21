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
                HStack{
                    ChatHandledByAI()
                    ChatHandledByAI()
                    ChatHandledByAI()
                }
                .padding(.horizontal)
                .padding(.top)
                .foregroundColor(.red)
                .frame(height : 200)
                
                
                HStack{
//                    ChartView()
//                    StatisticsView()
                }
                .padding(.horizontal)
                .padding(.bottom)
                .foregroundColor(Color.blue)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
            .background(.white)
            .padding(.bottom)
        }
    }
}

#Preview {
    DashboardView()
        .frame(width : 1000, height : 600)
        .padding()
}
