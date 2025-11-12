//
//  PhoneNumberUtility.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 11/11/25.
//


// PhoneNumberUtility.swift
// Utility untuk normalize format phone number untuk WhatsApp API

import Foundation

struct PhoneNumberUtility {
    
    /// Normalize phone number ke format WhatsApp API
    /// WhatsApp API requires: no +, no spaces, no dashes, country code included
    /// 
    /// Examples:
    /// - "+62 812-3456-7890" → "6281234567890"
    /// - "0812-3456-7890" → "6281234567890"
    /// - "+62-812-3456-7890" → "6281234567890"
    /// - "62 812 3456 7890" → "6281234567890"
    static func normalize(_ phoneNumber: String) -> String {
        // Remove all non-digit characters
        var digits = phoneNumber.filter { $0.isNumber }
        
        // Remove leading + if present (already removed by filter above)
        // Handle Indonesian numbers starting with 0
        if digits.hasPrefix("0") {
            // Replace leading 0 with 62 (Indonesia country code)
            digits = "62" + String(digits.dropFirst())
        }
        
        // Ensure country code is present
        if !digits.hasPrefix("62") && digits.count > 9 {
            // If no country code, assume Indonesia
            digits = "62" + digits
        }
        
        return digits
    }
    
    /// Validate if phone number is valid format
    static func isValid(_ phoneNumber: String) -> Bool {
        let normalized = normalize(phoneNumber)
        
        // Indonesian phone numbers:
        // - Start with 62
        // - Followed by 8-13 digits
        // - Total: 10-15 digits
        let isValidLength = normalized.count >= 10 && normalized.count <= 15
        let hasValidPrefix = normalized.hasPrefix("62")
        let isOnlyDigits = normalized.allSatisfy { $0.isNumber }
        
        return isValidLength && hasValidPrefix && isOnlyDigits
    }
    
    /// Format phone number for display (with separators)
    /// Example: "6281234567890" → "+62 812-3456-7890"
    static func formatForDisplay(_ phoneNumber: String) -> String {
        let normalized = normalize(phoneNumber)
        
        guard isValid(phoneNumber) else {
            return phoneNumber // Return original if invalid
        }
        
        // Format: +62 8XX-XXXX-XXXX
        let countryCode = String(normalized.prefix(2))
        let remaining = String(normalized.dropFirst(2))
        
        if remaining.count >= 10 {
            let part1 = String(remaining.prefix(3))
            let part2 = String(remaining.dropFirst(3).prefix(4))
            let part3 = String(remaining.dropFirst(7))
            return "+\(countryCode) \(part1)-\(part2)-\(part3)"
        } else if remaining.count >= 7 {
            let part1 = String(remaining.prefix(3))
            let part2 = String(remaining.dropFirst(3))
            return "+\(countryCode) \(part1)-\(part2)"
        } else {
            return "+\(countryCode) \(remaining)"
        }
    }
    
    /// Extract country code from phone number
    static func extractCountryCode(_ phoneNumber: String) -> String? {
        let normalized = normalize(phoneNumber)
        
        if normalized.hasPrefix("62") {
            return "62"
        }
        
        return nil
    }
}

// MARK: - String Extension
extension String {
    /// Quick normalize phone number
    var normalizedPhoneNumber: String {
        PhoneNumberUtility.normalize(self)
    }
    
    /// Check if valid phone number
    var isValidPhoneNumber: Bool {
        PhoneNumberUtility.isValid(self)
    }
    
    /// Format for display
    var formattedPhoneNumber: String {
        PhoneNumberUtility.formatForDisplay(self)
    }
}



// MARK: - Unit Tests
#if DEBUG
extension PhoneNumberUtility {
    static func runTests() {
        print("🧪 Running Phone Number Utility Tests\n")
        
        // Test normalization
        assert(normalize("+62 812-3456-7890") == "6281234567890", "Test 1 failed")
        assert(normalize("0812-3456-7890") == "6281234567890", "Test 2 failed")
        assert(normalize("+62-812-3456-7890") == "6281234567890", "Test 3 failed")
        assert(normalize("62 812 3456 7890") == "6281234567890", "Test 4 failed")
        assert(normalize("081234567890") == "6281234567890", "Test 5 failed")
        
        // Test validation
        assert(isValid("6281234567890") == true, "Test 6 failed")
        assert(isValid("+62 812-3456-7890") == true, "Test 7 failed")
        assert(isValid("123") == false, "Test 8 failed")
        assert(isValid("abc") == false, "Test 9 failed")
        
        // Test formatting
        assert(formatForDisplay("6281234567890") == "+62 812-3456-7890", "Test 10 failed")
        
        print("✅ All tests passed!\n")
        
        // Example outputs
        let testNumbers = [
            "+62 812-3456-7890",
            "0812-3456-7890",
            "+62-812-3456-7890",
            "62 812 3456 7890",
            "081234567890"
        ]
        
        print("Example conversions:")
        for phone in testNumbers {
            print("  \(phone.padding(toLength: 25, withPad: " ", startingAt: 0)) → \(normalize(phone))")
        }
    }
}
#endif
