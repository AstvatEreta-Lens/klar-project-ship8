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
                    
                    Menu("Today") {
                        Button(action: {}, label: {
                            Text("Today")
                                .foregroundColor(Color.textRegular)
                        })
                        Button(action: {}, label: {
                            Text("This Week")
                                .foregroundColor(Color.textRegular)
                        })
                        Button(action: {}, label: {
                            Text("This Month")
                                .foregroundColor(Color.textRegular)
                        })
                        Button(action: {}, label: {
                            Text("This Year")
                                .foregroundColor(Color.textRegular)
                        })
                    }
                    .foregroundStyle(Color.gray)
                }
                .padding(.vertical, 18)
                .padding(.horizontal)
                
                Spacer()
                    .frame(height : 58)
                
                VStack{
                    HStack{
                        UnresolvedChatView()
                        ChatHandledByAI()
                        ChatHandledByHuman()
                        TotalCustomerView()
                    }
                    
                    HStack{
                        SecondRowView(datas: .FRT)
                        SecondRowView(datas: .TTA)
                        SecondRowView(datas: .TTR)
                        SecondRowView(datas: .RR)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                .foregroundColor(.red)
                .frame(height : 200)
                
                
                HStack{
                    StatisticsView()
                        .chartXAxis(.visible)
                        .padding(.top, 40)
                    ConversationLabels(label : .warranty)
                        .padding(.top, -55)
                }
                .frame(maxHeight : 408)
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
        .frame(width : 1260, height : 982)
        .padding()
}
