//
//  SettingsView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

struct SettingsView: View {
    let editAction : () -> Void
    let saveAction : () -> Void
    
    var body: some View {
//        GeometryReader { geometry in
        VStack{
            
            // Header Section
            HStack{
                Text("Settings")
                    .padding()
                
                Spacer()
                
                Button(action : editAction){
                    HStack{
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                }
                
                Button(action : saveAction){
                    HStack{
                        Text("Save")
                    }
                }
                .padding(.trailing)
                  
                // Section
                
                    
                //        }
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.sectionHeader, lineWidth: 1)
        )
    }
}

#Preview {
    SettingsView(editAction: {}, saveAction: {})
        .padding()
}
