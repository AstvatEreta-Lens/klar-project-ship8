//
//  TestNumber.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 11/11/25.
//


// TestNumbersManager.swift
// Manage WhatsApp test numbers yang sudah registered di Meta Developer

import Foundation
import SwiftUI

// MARK: - Test Number Model
struct TestNumber: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var phoneNumber: String
    var isActive: Bool
    var addedAt: Date
    
    init(id: UUID = UUID(), name: String, phoneNumber: String, isActive: Bool = true, addedAt: Date = Date()) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.isActive = isActive
        self.addedAt = addedAt
    }
    
    var formattedPhoneNumber: String {
        PhoneNumberUtility.formatForDisplay(phoneNumber)
    }
    
    var normalizedPhoneNumber: String {
        PhoneNumberUtility.normalize(phoneNumber)
    }
}

// MARK: - Test Numbers Manager
class TestNumbersManager: ObservableObject {
    @Published var testNumbers: [TestNumber] = []
    
    private let userDefaults = UserDefaults.standard
    private let testNumbersKey = "whatsapp_test_numbers"
    
    init() {
        loadTestNumbers()
    }
    
    // MARK: - Load/Save
    func loadTestNumbers() {
        if let data = userDefaults.data(forKey: testNumbersKey),
           let decoded = try? JSONDecoder().decode([TestNumber].self, from: data) {
            testNumbers = decoded
            print("✅ Loaded \(testNumbers.count) test numbers")
        } else {
            // Add default test number if none exist
            testNumbers = []
            print("ℹ️ No test numbers found")
        }
    }
    
    func saveTestNumbers() {
        if let encoded = try? JSONEncoder().encode(testNumbers) {
            userDefaults.set(encoded, forKey: testNumbersKey)
            print("✅ Saved \(testNumbers.count) test numbers")
        }
    }
    
    // MARK: - Add/Remove
    func addTestNumber(name: String, phoneNumber: String) {
        let normalized = PhoneNumberUtility.normalize(phoneNumber)
        
        // Check if already exists
        if testNumbers.contains(where: { $0.normalizedPhoneNumber == normalized }) {
            print("⚠️ Test number already exists: \(normalized)")
            return
        }
        
        let testNumber = TestNumber(
            name: name,
            phoneNumber: normalized
        )
        
        testNumbers.append(testNumber)
        saveTestNumbers()
        
        print("✅ Added test number: \(name) - \(normalized)")
    }
    
    func removeTestNumber(_ testNumber: TestNumber) {
        testNumbers.removeAll { $0.id == testNumber.id }
        saveTestNumbers()
        print("🗑️ Removed test number: \(testNumber.name)")
    }
    
    func updateTestNumber(_ testNumber: TestNumber) {
        if let index = testNumbers.firstIndex(where: { $0.id == testNumber.id }) {
            testNumbers[index] = testNumber
            saveTestNumbers()
            print("✅ Updated test number: \(testNumber.name)")
        }
    }
    
    func toggleActive(_ testNumber: TestNumber) {
        if let index = testNumbers.firstIndex(where: { $0.id == testNumber.id }) {
            testNumbers[index].isActive.toggle()
            saveTestNumbers()
        }
    }
    
    // MARK: - Quick Access
    var activeTestNumbers: [TestNumber] {
        testNumbers.filter { $0.isActive }
    }
    
    func getTestNumber(by phoneNumber: String) -> TestNumber? {
        let normalized = PhoneNumberUtility.normalize(phoneNumber)
        return testNumbers.first { $0.normalizedPhoneNumber == normalized }
    }
    
    // MARK: - Create Conversation
    func createConversation(from testNumber: TestNumber) -> Conversation {
        return Conversation(
            name: testNumber.name,
            phoneNumber: testNumber.normalizedPhoneNumber,
            handlerType: .human,
            status: nil,
            messages: []
        )
    }
}

// MARK: - Test Numbers View
struct TestNumbersView: View {
    @StateObject private var manager = TestNumbersManager()
    @State private var showingAddNumber = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Test Numbers")
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
            
            // Info Banner
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("WhatsApp Test Numbers")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("Add phone numbers that are registered as test recipients in Meta Developer Console")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            
            // List
            if manager.testNumbers.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    
                    Image(systemName: "phone.badge.plus")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("No test numbers added")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Add numbers registered in Meta Developer Console")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: { showingAddNumber = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Test Number")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(manager.testNumbers) { testNumber in
                            TestNumberRow(
                                testNumber: testNumber,
                                onToggle: {
                                    manager.toggleActive(testNumber)
                                },
                                onDelete: {
                                    manager.removeTestNumber(testNumber)
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
            
            Divider()
            
            // Bottom Actions
            HStack {
                Text("\(manager.testNumbers.count) number(s) • \(manager.activeTestNumbers.count) active")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: { showingAddNumber = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Number")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
        }
        .frame(width: 500, height: 600)
        .sheet(isPresented: $showingAddNumber) {
            AddTestNumberView(manager: manager)
        }
    }
}

// MARK: - Test Number Row
struct TestNumberRow: View {
    let testNumber: TestNumber
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Active indicator
            Circle()
                .fill(testNumber.isActive ? Color.green : Color.gray)
                .frame(width: 8, height: 8)
            
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "person.fill")
                    .foregroundColor(.blue)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(testNumber.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(testNumber.formattedPhoneNumber)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Actions
            HStack(spacing: 8) {
                // Toggle active
                Button(action: onToggle) {
                    Image(systemName: testNumber.isActive ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(testNumber.isActive ? .green : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                .help(testNumber.isActive ? "Active" : "Inactive")
                
                // Delete
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
                .help("Delete")
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Add Test Number View
struct AddTestNumberView: View {
    @ObservedObject var manager: TestNumbersManager
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Add Test Number")
                    .font(.headline)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Form
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("e.g., Test Customer", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Display name for this contact")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone Number")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("e.g., +62 812-3456-7890", text: $phoneNumber)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Phone number registered in Meta Developer Console")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !phoneNumber.isEmpty {
                        if phoneNumber.isValidPhoneNumber {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Valid format: \(phoneNumber.normalizedPhoneNumber)")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        } else {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Invalid format")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
                
                // Info Box
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Important")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Text("This number must be added as a test recipient in your Meta Developer Console:\nWhatsApp → API Setup → To field")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
            
            Spacer()
            
            Divider()
            
            // Actions
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Add Number") {
                    addNumber()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || !phoneNumber.isValidPhoneNumber)
            }
            .padding()
        }
        .frame(width: 450, height: 500)
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func addNumber() {
        guard !name.isEmpty, phoneNumber.isValidPhoneNumber else {
            errorMessage = "Please enter valid name and phone number"
            showingError = true
            return
        }
        
        manager.addTestNumber(name: name, phoneNumber: phoneNumber)
        dismiss()
    }
}

// MARK: - Integration with ChatKlarView
extension ChatKlarView {
    // Add button to open Test Numbers Manager
    var testNumbersButton: some View {
        Button(action: {
            // Open test numbers view
        }) {
            Image(systemName: "phone.badge.plus")
                .font(.system(size: 16))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#if DEBUG
// MARK: - Preview
struct TestNumbersView_Previews: PreviewProvider {
    static var previews: some View {
        TestNumbersView()
    }
}
#endif