//
//  UnresolvedChatView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 20/11/25.
//

import SwiftUI

struct UnresolvedChatView: View {
    @State private var resolvedChats: Int = 0
    let targetChats: Int = 8
    let improvementPercent: Int = 3
    
    
    var body: some View {
        HStack(alignment : .top){
            VStack(alignment : .leading){
                    Text("Unresolved Chat")
                        .fontWeight(.light)
                        .font(.title3)
                        .foregroundColor(Color.black)
                    
                    Text("\(resolvedChats)")
                        .font(.system(size: 48, weight: .bold, design : .default))
                        .dynamicTypeSize(.accessibility1 ... .accessibility5)
                        .foregroundColor(Color.textRegular)
                        .shadow(color: Color.black.opacity(0.15), radius: 4, y: 2)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: resolvedChats)
                
                Spacer()
                
                    HStack{
                        Text("+\(improvementPercent)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("from yesterday")
                            .foregroundColor(Color.textRegular)
                            .font(.subheadline)
                            .fontWeight(.regular)
                    }
                    .padding(.bottom)
                    .foregroundColor(Color.red)
                }
                .padding(.top)
                .padding(.leading)
            
                Spacer()
            
                VStack{
                    Image("Photo Profile 2")
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
    UnresolvedChatView()
        .frame(width : 305, height : 151)
        .padding()
}
