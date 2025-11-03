//
//  MainChatView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//
import SwiftUI

struct MainChatView: View {
//    let takeOverButton : () -> Void
    
    var body: some View {
        VStack{
            // Bagian Atas
            HStack{
                ResolveButton(resolveAction: {})
                Spacer()
                SearchBar(text: .constant(""))
                    .frame(width: 206, height: 27)
            }
            .padding(.leading, 22)
            .padding(.trailing, 20)
            
            
            Divider()
            Spacer()
            
            
            // Main Chat
            Text("你好 fineshyt")
            
            
            
            Spacer()
            Divider()
            
            // Bawah
            TakeOverButton(takeoverAction: {})
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MainChatView()
        .padding()
//        .frame(width: 600, height: 900)
}
