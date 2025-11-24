//
//  AddFilesView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 15/11/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct AddFilesView: View {
    @ObservedObject var viewModel: KnowledgeViewModel
    let closeAction: () -> Void
    let continueAction: () -> Void
    
    @State private var isTargeted: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Upload Files")
                    .foregroundColor(Color.textRegular)
                    .font(.body)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                    .padding(.leading, 10)
                
                Spacer()
                
                Button(action: closeAction) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.avatarCount)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Text("Add new knowledge base files. Supported type .PDF only")
                .font(.body)
                .foregroundColor(Color.textRegular)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.bottom, 24)
            
            // Drop Zone
            ZStack {
                RoundedRectangle(cornerRadius: 11)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundColor(isTargeted ? Color.sectionHeader.opacity(0.8) : Color.sectionHeader)
                    .frame(width: 656, height: 220)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .fill(isTargeted ? Color.sectionHeader.opacity(0.1) : Color.clear)
                    )
                
                VStack {
                    Image("uploadSymbol")
                        .frame(width: 110, height: 100)
                    
                    HStack(spacing: 1) {
                        Text("drag & drop files or ")
                            .foregroundColor(Color.textRegular)
                        Button(action: {
                            viewModel.openFilePicker()
                        }) {
                            Text("open folder")
                                .foregroundColor(Color.sectionHeader)
                                .underline()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            // On drop file
            .onDrop(of: [UTType.fileURL], isTargeted: $isTargeted) { providers in
                viewModel.handleDroppedFiles(providers: providers)
                return true
            }
            
            // Uploading Files List
            ScrollView(.horizontal) {
                HStack(spacing: 7) {
                    ForEach(viewModel.uploadingFiles) { uploadingFile in
                        UploadingPDFsCard(
                            fileName: uploadingFile.fileName,
                            progress: uploadingFile.progress,
                            isCompleted: uploadingFile.isCompleted,
                            onRemove: {
                                viewModel.removeUploadingFile(uploadingFile.id)
                            }
                        )
                    }
                }
                .padding(.vertical, 0.5)
                .padding(.horizontal, 0.5)
            }
            .frame(width: 656, height: 50)
            .padding(.bottom, 13)
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
            
            // Continue Button
            Button(action: {
                viewModel.saveCompletedUploads()
                continueAction()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 11)
                        .frame(width: 656, height: 36)
                        .foregroundColor(Color.sectionHeader)
                    
                    Text("Continue")
                        .foregroundColor(Color.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(viewModel.uploadingFiles.contains(where: { !$0.isCompleted }) || viewModel.uploadingFiles.isEmpty)
            .opacity((viewModel.uploadingFiles.contains(where: { !$0.isCompleted }) || viewModel.uploadingFiles.isEmpty) ? 0.6 : 1.0)
        }
        .padding()
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
    AddFilesView(
        viewModel: KnowledgeViewModel(),
        closeAction: {},
        continueAction: {}
    )
    .padding()
}
