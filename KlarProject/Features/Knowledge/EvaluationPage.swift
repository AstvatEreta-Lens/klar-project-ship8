//
//  EvaluationPage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 11/11/25.
//

import SwiftUI

struct EvaluationPage: View {
    var body: some View {
        GeometryReader { geometry in
            HStack{
                // Header
                EvaluationView(viewModel: ConversationListViewModel())
                
                Divider()
                    .frame(height: geometry.size.height)
                    .background(Color.borderColor)
                
                ZStack {
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Evaluation Page")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                    }
                }
                
                Divider()
                    .frame(height: geometry.size.height)
                    .background(Color.borderColor)
                
                Text("Placeholder le")
                    .padding(.trailing)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .padding()
    }
}

#Preview {
    EvaluationPage()
}
