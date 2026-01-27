//
//  KnowledgePage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import SwiftUI

struct KnowledgePage: View {
    @StateObject private var viewModel = KnowledgeViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                KnowledgeView(viewModel : viewModel, action: {})
                
                Divider()
                
                Text("hoho")
                    .frame(width : 897, height: 982)
            }
            
        .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    KnowledgePage()
}
