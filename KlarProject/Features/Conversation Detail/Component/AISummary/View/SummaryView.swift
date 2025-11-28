//
//  AISummaryView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 02/11/25.
//

import SwiftUI

struct AISummaryView: View {
    @StateObject private var viewModel: AISummaryViewModel
    let messages: [Message]
    
    init(conversationId: UUID, messages: [Message]) {
        self.messages = messages
        _viewModel = StateObject(wrappedValue: AISummaryViewModel(conversationId: conversationId))
    }
    
    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .frame(width: 307, height: 177)
                .foregroundColor(Color.componentBackgroundColor)
                .cornerRadius(11)
                .overlay(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(Color.avatarCount, lineWidth: 1)
                )
            
            // Content
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    loadingView
                } else if let summary = viewModel.summary {
                    summaryCard(summary)
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else {
                    emptyStateView
                }
            }
            .frame(width: 307, height: 177)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        ZStack {
                Rectangle()
                    .frame(width: 307, height: 177)
                    .foregroundColor(Color(hex : "#FEFEFE"))
                    .cornerRadius(11)
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(Color.avatarCount, lineWidth: 1)
                    )
                
                VStack{
                    Image(systemName: "hand.raised")
                        .font(.system(size: 30))
                        .foregroundColor(Color.sectionHeader)
                        .padding(.top, 26)
                        .padding(.bottom, 13)
                    
                    Text("No summary yet.")
                        .font(.callout)
                        .foregroundColor(Color.black)
                    
                    Text("Tap button below to generate AI summary.")
                        .font(.callout)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await viewModel.generateSummary(from: messages)
                        }
                    }) {
                        Text("Generate AI Summary")
                            .foregroundColor(Color.sectionHeader)
                            .overlay(
                                RoundedRectangle(cornerRadius: 11)
                                    .stroke(.sectionHeader, lineWidth: 1)
                                    .frame(width: 287, height: 36)
                            )
                            .frame(width: 287, height: 36)
                    }
                    .padding(.bottom, 5)
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(width: 307, height: 177)
            }
    }
    
    // MARK: - Loading State
    private var loadingView: some View {
        ZStack {
                Rectangle()
                    .frame(width: 307, height: 177)
                    .foregroundColor(Color.componentBackgroundColor)
                    .cornerRadius(11)
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(Color.avatarCount, lineWidth: 1)
                    )
                
                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding(.top, 35)
                    
                    Text("Generating conversation summary...")
                        .font(.caption)
                        .foregroundColor(Color.grayTextColor)
                    
                    Spacer()
                    
                    Text("Loading...")
                        .font(.caption)
                        .foregroundColor(Color.white)
                        .frame(width: 287, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 11)
                                .foregroundColor(Color.gray.opacity(0.7))
                        )
                }
                .frame(width: 307, height: 177)
                .padding(.bottom)
            }
    }
    
    
    // MARK: - Summary Card
    private func summaryCard(_ summary: AISummary) -> some View {
        ZStack {
            Rectangle()
                .frame(width: 307, height: 177)
                .foregroundColor(Color.componentBackgroundColor)
                .cornerRadius(11)
                .overlay(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(Color.avatarCount, lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                // Header with menu
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.caption)
                            .foregroundColor(Color.sectionHeader)
                        
                        Text("AI Summary")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary)
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button(action: {
                            Task {
                                await viewModel.regenerateSummary(from: messages)
                            }
                        }) {
                            Label("Regenerate", systemImage: "arrow.clockwise")
                        }
                        
                        Button(role: .destructive, action: {
                            Task {
                                await viewModel.deleteSummary()
                            }
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.caption)
                            .foregroundColor(Color.grayTextColor)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
                
                // Summary text
                ScrollView {
                    Text(summary.summary)
                        .font(.caption)
                        .foregroundColor(Color.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .padding(.horizontal, 12)
                }
                .frame(maxHeight: 100)
                
                // Copy action
                HStack {
                    Button(action: {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(summary.summary, forType: .string)
                    }) {
                        Text("Copy")
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .frame(width: 206, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .foregroundColor(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 11)
                                            .stroke(Color.sectionHeader, lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // Edit action
                    }) {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .frame(width: 37, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .foregroundColor(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 11)
                                            .stroke(Color.sectionHeader, lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        Task {
                            await viewModel.regenerateSummary(from: messages)
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                            .foregroundColor(Color.white)
                            .frame(width: 37, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .foregroundColor(Color.sectionHeader)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                
                // Update badge if needed
                if viewModel.needsUpdate(currentMessageCount: messages.count) {
                    HStack(spacing: 4) {
                        Image(systemName: "info.circle.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        
                        Text("\(messages.count - summary.messageCount) new messages")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        
                        Spacer()
                        
                        Button("Update") {
                            Task {
                                await viewModel.regenerateSummary(from: messages)
                            }
                        }
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .cornerRadius(6)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
            }
            .frame(width: 307, height: 177)
        }
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    
    // MARK: - Error State
    private func errorView(_ message: String) -> some View {
        ZStack {
            Rectangle()
                .frame(width: 307, height: 177)
                .foregroundColor(Color.componentBackgroundColor)
                .cornerRadius(11)
                .overlay(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(Color.avatarCount, lineWidth: 1)
                )
            
            VStack(spacing: 12) {
                Spacer()
                Image(systemName: "xmark")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
                    .padding(.top, 40)
                
                Text(message)
                    .font(.caption)
                    .foregroundColor(Color.grayTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("")
                    .font(.caption)
                
                
                Button(action: {
                    Task {
                        await viewModel.generateSummary(from: messages)
                    }
                }) {
                    Text("Generate AI Summary")
                        .font(.caption)
                        .foregroundColor(Color.white)
                        .frame(width: 287, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 11)
                                .foregroundColor(Color.gray.opacity(0.7))
                        )
                }
                .padding(.bottom, 34)
                .buttonStyle(PlainButtonStyle())
            }
            .frame(width: 307, height: 177)
        }
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Preview Helper

#Preview("Empty State - No Messages") {
        AISummaryView(
            conversationId: UUID(),
            messages: []
        )
    .padding()
}

#Preview("1. Empty State") {
     AISummaryView(
         conversationId: UUID(),
         messages: []
     )
     .padding()
 }
 #Preview("4. Summary with Content") {
     PreviewSummaryState()
         .padding()
 }

 #Preview("6. Error State") {
     PreviewErrorState()
         .padding()
 }

 // MARK: - Preview Helper Views

 // Preview wrapper for Loading state
 private struct PreviewLoadingState: View {
     @StateObject private var viewModel = PreviewViewModel(state: .loading)

     var body: some View {
         ZStack {
             Rectangle()
                 .frame(width: 307, height: 177)
                 .foregroundColor(Color.componentBackgroundColor)
                 .cornerRadius(11)
                 .overlay(
                     RoundedRectangle(cornerRadius: 11)
                         .stroke(Color.avatarCount, lineWidth: 1)
                 )

             VStack(spacing: 12) {
                 ProgressView()
                     .progressViewStyle(.circular)
                     .padding(.top, 35)

                 Text("Generating conversation summary...")
                     .font(.caption)
                     .foregroundColor(Color.grayTextColor)
                 Spacer()
                 Text("Loading...")
                     .font(.caption)
                     .foregroundColor(Color.white)
                     .frame(width: 294, height: 36)
                     .background(
                         RoundedRectangle(cornerRadius: 11)
                             .foregroundColor(Color.sectionHeader)
                     )
             }
             .frame(width: 307, height: 177)
             .padding(.bottom)
         }
         .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
     }
 }


 // Preview wrapper for Summary with content
private struct PreviewSummaryState: View {
    private let dummySummary = createDummySummary(messageCount: 6)
    private let dummyMessages = createDummyMessages()
    let pencilAction: () -> Void = { }
    let reloadAction: () -> Void = { }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 307, height: 177)
                .foregroundColor(Color.componentBackgroundColor)
                .cornerRadius(11)
                .overlay(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(Color.avatarCount, lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                // Header with menu
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.caption)
                            .foregroundColor(Color.sectionHeader)
                        
                        Text("02.29")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
                
                // Summary text
                ScrollView {
                    Text(dummySummary.summary)
                        .font(.caption)
                        .foregroundColor(Color.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .padding(.horizontal, 12)
                }
                .frame(maxHeight: 100)
                
                HStack{
                    // Metadata footer
                    Button(action: {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(dummySummary.summary, forType: .string)
                    }) {
                        Text("Copy")
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .frame(width: 206, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .foregroundColor(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 11)
                                            .stroke(Color.sectionHeader, lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action:pencilAction){
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .frame(width: 37, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .foregroundColor(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 11)
                                            .stroke(Color.sectionHeader, lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action:reloadAction){
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                            .foregroundColor(Color.white)
                            .frame(width: 37, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .foregroundColor(Color.sectionHeader)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .frame(width: 307, height: 177)
    }
//        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
}



 // Preview wrapper for Error state
 private struct PreviewErrorState: View {
     var body: some View {
         ZStack {
             Rectangle()
                 .frame(width: 307, height: 177)
                 .foregroundColor(Color.componentBackgroundColor)
                 .cornerRadius(11)
                 .overlay(
                     RoundedRectangle(cornerRadius: 11)
                         .stroke(Color.avatarCount, lineWidth: 1)
                 )

             VStack(spacing: 12) {
                 Image(systemName: "xmark")
                     .font(.system(size: 40))
                     .foregroundColor(.gray)
                     .padding(.top, 40)

                 Text("Not enough messages to summarize yet")
                     .font(.caption2)
                     .foregroundColor(Color.grayTextColor)
                     .multilineTextAlignment(.center)
                     .padding(.horizontal, 20)

                 Spacer()

                 Text("Generate AI Summary")
                     .font(.caption)
                     .foregroundColor(Color.white)
                     .frame(width: 287, height: 36)
                     .background(
                         RoundedRectangle(cornerRadius: 11)
                             .foregroundColor(Color.gray.opacity(0.7))
                     )
                     .padding(.top, 16)
                     .padding(.bottom)
             }
             .frame(width: 307, height: 177)
         }
         .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
     }
 }


 private class PreviewViewModel: ObservableObject {
     enum State {
         case loading
         case generating
     }

     init(state: State) {}
 }

 private func createDummyMessages() -> [Message] {
     let conversationId = UUID()
     let customer = Customer(
         name: "Budi Santoso",
         phoneNumber: "+62812345678",
         profileImage: ""
     )
     let agent = User(
         id: UUID(),
         name: "Sarah",
         profileImage: "",
         email: "sarah@example.com"
     )

     return Message.dummyMessages(
         conversationId: conversationId,
         customer: customer,
         agent: agent
     )
 }

 private func createDummyMessagesWithExtra() -> [Message] {
     var messages = createDummyMessages()
     let conversationId = messages.first!.conversationId
     let customer = Customer(
         name: "Budi Santoso",
         phoneNumber: "+62812345678",
         profileImage: ""
     )

     // Add 2 more messages
     messages.append(Message(
         conversationId: conversationId,
         sender: .customer(customer),
         content: "Oke noted, kapan bisa datang?",
         timestamp: Date().addingTimeInterval(-60),
         status: .sent
     ))

     messages.append(Message(
         conversationId: conversationId,
         sender: .customer(customer),
         content: "Saya tunggu ya min!",
         timestamp: Date(),
         status: .sent
     ))

     return messages
 }

 private func createDummySummary(messageCount: Int) -> AISummary {
     AISummary(
         conversationId: UUID(),
         summary: "Customer melaporkan mesin tipe XZ-500 mengalami kerusakan total. Agent mengidentifikasi kemungkinan masalah di starter motor atau relay. Customer masih dalam masa garansi, dan agent telah menjadwalkan kunjungan teknisi dalam 1-2 hari kerja untuk proses klaim garansi.",
         generatedAt: Date().addingTimeInterval(-120), // 2 minutes ago
         messageCount: messageCount
     )
 }

