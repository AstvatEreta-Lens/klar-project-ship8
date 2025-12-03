//
//  NewConversationDialog.swift
//  KlarProject
//
//  Dialog for starting a new conversation with a phone number
//
import SwiftUI
import Combine

struct NewConversationDialog: View {
    @Binding var isPresented: Bool
    @State private var phoneNumber: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var nameContact: String = ""
    
    // ✅ Update signature untuk pass nama juga
    let onStartConversation: (String, String) async -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if !isLoading {
                            isPresented = false
                        }
                    }
                
                VStack(spacing: 16) {
                    // Header
                    HStack {
                        Text("Mulai Percakapan Baru")
                            .font(.headline)
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.system(size: 20))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Divider()
                    
                    // Name Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.subheadline)
                            .foregroundColor(.secondaryText)
                        
                        TextField("Alex Doe", text: $nameContact)
                            .textFieldStyle(.plain)
                            .padding(10)
                            .background(Color.chatInputBackground)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.borderColor, lineWidth: 1)
                            )
                            .autocorrectionDisabled()
                    }
                    
                    // Phone Number Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Number")
                            .font(.subheadline)
                            .foregroundColor(.secondaryText)
                        
                        TextField("Contoh: 6281234567890", text: $phoneNumber)
                            .textFieldStyle(.plain)
                            .padding(10)
                            .background(Color.chatInputBackground)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.borderColor, lineWidth: 1)
                            )
                            .autocorrectionDisabled()
                        
                        Text("Masukkan nomor WhatsApp yang sudah terdaftar di Meta Developer")
                            .font(.caption)
                            .foregroundColor(.tertiaryText)
                    }
                    
                    // Error Message
                    if let errorMessage = errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button("Batal") {
                            isPresented = false
                        }
                        .buttonStyle(.bordered)
                        .textCase(nil)
                        
                        Button("Mulai") {
                            Task {
                                await startConversation()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .textCase(nil)
                        .disabled(phoneNumber.isEmpty || isLoading)
                        
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(20)
                .frame(
                    width: min(450, geometry.size.width * 0.8),
                    height: nil
                )
                .background(Color.backgroundPrimary)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
            }
        }
    }
    
    private func startConversation() async {
        let cleanedNumber = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedName = nameContact.trimmingCharacters(in: .whitespacesAndNewlines)
    
        
        // Basic validation
        guard !cleanedNumber.isEmpty else {
            errorMessage = "Nomor tidak boleh kosong"
            return
        }
        
        // Remove common formatting characters
        let formattedNumber = cleanedNumber
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
        
        // Validate it's numeric
        guard formattedNumber.allSatisfy({ $0.isNumber }) else {
            errorMessage = "Nomor harus berupa angka"
            return
        }
        
        // Minimum length check
        guard formattedNumber.count >= 10 else {
            errorMessage = "Nomor terlalu pendek"
            return
        }
        
        errorMessage = nil
        isLoading = true
        
        // ✅ Pass nama dan nomor
        await onStartConversation(formattedNumber, cleanedName)

        
        isLoading = false
        isPresented = false
        phoneNumber = ""
        nameContact = ""
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
        NewConversationDialog(
            isPresented: .constant(true),
            onStartConversation: { phoneNumber, name in
                print("Start conversation with: \(phoneNumber), name: \(name)")
            }
        )
    }
}
