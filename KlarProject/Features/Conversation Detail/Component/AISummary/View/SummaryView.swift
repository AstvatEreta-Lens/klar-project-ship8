//
//  Summary.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 29/10/25.
//

import SwiftUI

struct Summary : View {
    let generateAISummary : () -> Void
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width : 307, height : 177)
                .foregroundColor(Color.componentBackgroundColor)
                .cornerRadius(11)
                .overlay(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(Color.avatarCount, lineWidth: 1)
                )
            
            
            VStack{
                Image(systemName: "hand.raised")
                    .font(.system(size: 40))
                    .foregroundColor(Color.componentComponentColor)
                    .padding(.top, 27)
                
                Text("No summary yet.")
                    .font(.system(size: 11))
                    .foregroundColor(Color.grayTextColor)
                Text("Tap button below to generate AI summary.")
                    .font(.system(size: 11))
                    .foregroundColor(Color.grayTextColor)
                
                Button(action : generateAISummary){
                    Text("Generate AI Summary")
                        .font(.caption)
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(width: 297, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 11)
                                .foregroundColor(Color.sectionHeader)
                        )
                }
                .padding(.top,29)
                .padding(.bottom, 5)
                .padding(.horizontal, 5)
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    Summary(generateAISummary: {})
        .padding()
}
