//
//  ChatHandledByAI.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/11/25.
//

import SwiftUI

struct ChatHandledByAI: View {
    @State private var resolvedChats: Int = 0
    let targetChats: Int = 12
    let improvementPercent: Double = 3.0
    
    
    var body: some View {
        HStack(alignment : .top){
            VStack(alignment : .leading){
                    Text("Chat Handled by AI")
                        .fontWeight(.light)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#1A1A1A"))
                    
                    Text("\(resolvedChats)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Color.textRegular)
                        .shadow(color: Color.black.opacity(0.15), radius: 4, y: 2)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: resolvedChats)
                Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: improvementPercent >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("\(String(format: "%.0f", improvementPercent))%")
                            .font(.caption)
                            .fontWeight(.medium)
                        Text("from yesterday")
                            .foregroundColor(Color.textRegular)
                            .font(.caption)
                            .fontWeight(.light)
                    }
                    .padding(.bottom)
                    .foregroundColor(Color.green)
                }
                .padding(.top)
                .padding(.leading)
            
                Spacer()
            
                VStack{
                    Image("Photo Profile 1")
                        .frame(width : 90, height : 90)
                    Spacer()
                }
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
//        .padding()
        .onAppear {
            withAnimation {
                resolvedChats = targetChats
            }
        }
    }
}

#Preview {
    ChatHandledByAI()
        .frame(width : 305, height : 151)
        .padding()
}
