//
//  Label.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 28/10/25.
//

import SwiftUI

enum LabelType : String, Codable, CaseIterable,Hashable {
    case warranty
    case service
    case payment
    case maintenance
    case spareparts
    

    var text: String {
        switch self {
        case .warranty: return "Warranty"
        case .service: return "Service"
        case .payment: return "Payment"
        case .maintenance: return "Maintenance"
        case .spareparts: return "Spareparts"
        }
    }
}

struct LabelView: View {
    let label: LabelType
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label.text)
                .foregroundColor(Color.labelBorderColor)
                .font(.caption)
            
            Button(action: action) {
                Image(systemName: "xmark")
                    .foregroundColor(Color.labelBorderColor)
                    .font(.caption)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 6)
        .frame(height: 18)
        .background(
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.labelBorderColor, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.labelBorderColor, lineWidth: 1)
                        .fill(Color.white)
                )
        )
        .fixedSize()
    }
}

#Preview {
    VStack(spacing : 10){
        LabelView(label: .warranty) { print("Warranty clicked") }
        LabelView(label: .service) { print("Service clicked") }
        LabelView(label: .payment) { print("Payment clicked") }
        LabelView(label: .maintenance) { print("Maintenance clicked") }
        LabelView(label: .spareparts) { print("Spareparts clicked") }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
