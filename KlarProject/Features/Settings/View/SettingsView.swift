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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.sectionHeader)
                    .padding()
                
                Spacer()
                
                Button(action : editAction){
                    HStack{
                        Image(systemName: "pencil")
                            .font(.title2)
                        Text("Edit")
                            .font(.title2)
                    }
                    
                    .frame(width : 110, height : 36)
                }
                .cornerRadius(11)
                .foregroundColor(Color.gray)
                
                Button(action : saveAction){
                    HStack{
                        Text("Save")
                            .font(.title2)
                            .foregroundColor(Color.white)
                    }
                    
                    .frame(width : 57, height : 36)
                }
                .background(Color.sectionHeader)
                .cornerRadius(11)
                .padding(.trailing)
                  
                //        }
            }
          AccountTabView(viewModel: SettingsViewModel())
                .padding(.horizontal, 252)
            
          SecurityTabView(viewModel: SettingsViewModel())
                .padding(.horizontal, 252)
            
            PlatformConfigView(viewModel : SettingsViewModel(), tutorialAction: {})
                .padding(.horizontal, 252)
            
            
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.sectionHeader, lineWidth: 1)
        )
    }
}

#Preview {
    SettingsView(editAction: {}, saveAction: {})
        .frame(width : 1279)
        .padding()
}
