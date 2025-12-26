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
        case .warranty: return NSLocalizedString("Warranty", comment : "")
        case .service: return NSLocalizedString("Service", comment : "")
        case .payment: return NSLocalizedString("Payment", comment : "")
        case .maintenance: return NSLocalizedString("Maintenance", comment : "")
        case .spareparts: return NSLocalizedString("Spareparts", comment : "")
        }
    }
}

struct LabelView: View {
    let label: LabelType
    let action: () -> Void
    
    var body: some View {
        HStack{
            Text(label.text)
                .foregroundColor(Color(hex : "#4D4D4D"))
                .font(.callout)
            
            Button(action: action) {
                Image(systemName: "xmark")
                    .foregroundColor(Color(hex : "#4D4D4D"))
                    .font(.caption)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .frame(height: 22)
        .background(
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.gray, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(hex : "#EEEEE"), lineWidth: 1)
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
