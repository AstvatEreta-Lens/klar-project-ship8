//
//  ChatView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 10/11/25.
//

// NewChatView.swift
// View untuk memulai chat baru dengan test number

import SwiftUI

struct NewChatView: View {
    @ObservedObject var testNumbersManager: TestNumbersManager
    let onCreateChat: (TestNumber) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedTestNumber: TestNumber?
    @State private var searchText: String = ""
    
    var filteredTestNumbers: [TestNumber] {
        if searchText.isEmpty {
            return testNumbersManager.activeTestNumbers
        }
        return testNumbersManager.activeTestNumbers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.phoneNumber.contains(searchText)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("New Chat")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Search
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search test numbers...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(10)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .padding()
            
            // Test Numbers List
            if filteredTestNumbers.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    
                    if testNumbersManager.testNumbers.isEmpty {
                        Image(systemName: "phone.badge.plus")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("No test numbers added")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Add test numbers in Settings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else if testNumbersManager.activeTestNumbers.isEmpty {
                        Image(systemName: "phone.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("No active test numbers")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Activate test numbers in Settings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("No results found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Try different search terms")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredTestNumbers) { testNumber in
                            TestNumberSelectRow(
                                testNumber: testNumber,
                                isSelected: selectedTestNumber?.id == testNumber.id,
                                onSelect: {
                                    selectedTestNumber = testNumber
                                }
                            )
                            
                            if testNumber.id != filteredTestNumbers.last?.id {
                                Divider()
                                    .padding(.leading, 60)
                            }
                        }
                    }
                }
            }
            
            Divider()
            
            // Bottom Actions
            HStack {
                Text("\(filteredTestNumbers.count) available")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Button("Start Chat") {
                    if let testNumber = selectedTestNumber {
                        onCreateChat(testNumber)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedTestNumber == nil)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
        }
        .frame(width: 450, height: 600)
    }
}

// MARK: - Test Number Select Row
struct TestNumberSelectRow: View {
    let testNumber: TestNumber
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.blue : Color.blue.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    } else {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(testNumber.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(testNumber.formattedPhoneNumber)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // WhatsApp icon
                Image("whatsapp") // Use your WhatsApp icon asset
                    .resizable()
                    .frame(width: 20, height: 20)
                    .opacity(0.6)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? Color.blue.opacity(0.05) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#if DEBUG
struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = TestNumbersManager()
        manager.testNumbers = [
            TestNumber(name: "Test Customer 1", phoneNumber: "6281234567890"),
            TestNumber(name: "Test Customer 2", phoneNumber: "6289876543210"),
            TestNumber(name: "John Doe", phoneNumber: "6282216860317")
        ]
        
        return NewChatView(
            testNumbersManager: manager,
            onCreateChat: { testNumber in
                print("Creating chat with: \(testNumber.name)")
            }
        )
    }
}
#endif
