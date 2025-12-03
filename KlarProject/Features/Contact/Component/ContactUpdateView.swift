//
//  ContactUpdateView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 18/11/25.
//

import SwiftUI

struct ContactUpdateView: View {
    var body: some View {
        VStack(alignment : .trailing){
            Image(systemName: "xmark")
                .foregroundColor(Color.textRegular)
            
            Text("Contact Details")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.textRegular)
            
            
            HStack{
                // Name, phone number, dkk
                VStack(alignment : .leading){
                    Text("Name")
                        .foregroundColor(Color.textRegular)
                    
                    Text("Phone Number")
                        .foregroundColor(Color.textRegular)
                    Text("Address")
                        .foregroundColor(Color.textRegular)
                }
                // Pick the channle
                VStack{
                    HStack{
                        Text("Pick the channel")
                            .foregroundColor(Color.textRegular)
                    }
                    
                    HStack{
                        Text("Tags")
                            .foregroundColor(Color.textRegular)
                        
                        // Tags
                    }
                }
            }
            Text("halo")
                .foregroundColor(Color.textRegular)
        }
        .frame(width: 700, height: 435)
        .background(Color.white)
        .cornerRadius(11)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.sectionHeader, lineWidth: 1)
        )
        .shadow(radius: 10)
    }
}

#Preview {
    ContactUpdateView()
        .padding()
}
