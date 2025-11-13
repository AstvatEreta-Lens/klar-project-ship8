//
//  KnowledgePage.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import SwiftUI

//private struct CustomSegmentedPickerViewWrapper: View {
//    @Binding var selection: Int
//    @State private var internalSelection: Int = 0
//
//    var body: some View {
//        CustomSegmentedPickerView()
//            .onChange(of: internalSelection) { _, newValue in
//                selection = newValue
//            }
//            .onChange(of: selection) { _, newValue in
//                internalSelection = newValue
//            }
//            .onAppear {
//                internalSelection = selection
//            }
//    }
//}

struct KnowledgePage: View {
    
    @State private var title: String = "Knowledge"
    @State private var selectedTab: Int = 0
    @StateObject private var viewModel = KnowledgeViewModel()
    @StateObject private var evaluationViewModel = EvaluationViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack {
                        Text(title)
                            .foregroundColor(Color.primaryText)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 14)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .layoutPriority(1)
                        
//                        Spacer()
                        
                        CustomSegmentedPickerView(selectedIndex: $selectedTab)
                            .frame(width : 169, height : 36)
                            .padding(.vertical, 4)
                            .padding(.leading, 70)
                    }
                    .frame(height: 60)
                    .padding(.top, 10)
                    
                    Divider()
                        .background(Color.borderColor)
                        .padding(.bottom)
                    
                    if selectedTab == 0 {
                        KnowledgeView(viewModel: viewModel, action: {})
                            .frame(width: 399)
                    } else if selectedTab == 1 {
                        EvaluationView(evaluationViewModel: evaluationViewModel)
                            .frame(width: 399)
                    }
                    
                    Spacer()
                }
                .frame(width: 440)
                .background(Color.backgroundPrimary)
                
                Divider()
                    .frame(height: geometry.size.height)
                    .background(Color.borderColor)
                
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    if selectedTab == 0, let selectedPDF = viewModel.selectedPDF {
                        PDFViewer(pdfURL: selectedPDF.fileURL)
                            .padding()
                    } else if selectedTab == 0 {
                        VStack {
                            Image("LogoFix")
                                .frame(width: 213, height: 48)
                            Text("Select a file to see the content")
                                .foregroundColor(Color.secondaryText)
                        }
                    } else if selectedTab == 1, let conversation = evaluationViewModel.selectedConversation {
                        EvaluationDetailView(
                            conversation: conversation,
                            canApprove: evaluationViewModel.canApprove(conversation),
                            onRemove: {
                                evaluationViewModel.removeConversation(conversation)
                            },
                            onEdit: {
                                // add edit logic
                            },
                            onApprove: {
                                evaluationViewModel.approveConversation(conversation)
                            }
                        )
                        .padding()
                    } else if selectedTab == 1 {
                        VStack(spacing: 12) {
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 48))
                                .foregroundColor(Color.secondaryText.opacity(0.6))
                            
                            Text("Select a conversation to view evaluation details")
                                .foregroundColor(Color.secondaryText)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.backgroundPrimary)
        }
        .environmentObject(viewModel)
    }
}


#Preview {
    KnowledgePage()
        .padding(.leading)
}
