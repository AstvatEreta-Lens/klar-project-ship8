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
        GeometryReader { geometry in
            let contentPadding = max(20, min(252, (geometry.size.width - 775) / 2))

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
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .cornerRadius(11)
                    .foregroundColor(Color.gray)

                    Button(action : saveAction){
                        HStack{
                            Text("Save")
                                .font(.title2)
                                .foregroundColor(Color.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    }
                    .background(Color.sectionHeader)
                    .cornerRadius(11)
                    .padding(.trailing)

                }
                
                AccountTabView(viewModel: SettingsViewModel())
                    .padding(.horizontal, contentPadding)

                SecurityTabView(viewModel: SettingsViewModel())
                    .padding(.horizontal, contentPadding)

                PlatformConfigView(viewModel : SettingsViewModel(), tutorialAction: {})
                    .padding(.horizontal, contentPadding)



            }
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 11)
                    .stroke(Color.sectionHeader, lineWidth: 1)
            )
            .padding(.bottom)
        }
    }
}

#Preview {
    SettingsView(editAction: {}, saveAction: {})
        .frame(width : 1279)
        .padding()
}
