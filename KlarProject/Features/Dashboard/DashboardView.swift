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
                    Text("Dashboard")
                        .font(.largeTitle)
                        .foregroundColor(Color.sectionHeader)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("Picker")
                }
                .padding(.top, 18)
                .padding(.horizontal)
                
                HStack{
                    UnresolvedChatView()
                    ChatHandledByAI()
                    ChatHandledByHuman()
                    TotalCustomerView()
                }
                .padding(.horizontal)
                .padding(.top)
                .foregroundColor(.red)
                .frame(height : 200)
                
                
                HStack(alignment : .top){
                    StatisticsView()
                        .chartXAxis(.visible)
                        .frame(maxHeight : 408)
                    ConversationLabels(label : .warranty)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                Spacer()
                
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(hex: "#E7F4F5")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
//            .padding()
        }
    }
}

#Preview {
    DashboardView()
        .frame(width : 1260, height : 600)
        .padding()
}
