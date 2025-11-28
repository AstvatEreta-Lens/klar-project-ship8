//
//  SecondRowView.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 26/11/25.
//

import SwiftUI

enum seconRowDatas : String {
    case FRT
    case TTA
    case TTR
    case RR
    
    var headerText : String{
        switch self {
        case .FRT :
            return "First Response Time"
        case .TTA:
            return "Time to Answer"
        case .TTR:
            return "Time to Resolve"
        case .RR:
            return "Response Rate"
        }
    }
    
    var timeText : String{
        switch self {
        case .FRT :
            return "1m20s"
        case .TTA:
            return "1m20s"
        case .TTR:
            return "4m50s"
        case .RR:
            return "2.4%"
        }
    }
    
    var bottomPercentageeText : String{
        switch self {
        case .FRT :
            return "1.2%"
        case .TTA:
            return "1.2%"
        case .TTR:
            return "4.5%"
        case .RR:
            return "2.4%"
        }
    }
}


struct SecondRowView: View {
    let datas : seconRowDatas
    
    var body: some View {
        HStack(alignment : .top){
            VStack(alignment : .leading){
                Text(datas.headerText)
                        .fontWeight(.light)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#1A1A1A"))
                    
                Text(datas.timeText)
                        .font(.system(size: 48, weight: .bold, design : .default))
                        .dynamicTypeSize(.accessibility1 ... .accessibility5)
//                        .minimumScaleFactor(0.8)
                        .foregroundColor(Color.textRegular)
                        .shadow(color: Color.black.opacity(0.15), radius: 4, y: 2)
                Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text(datas.bottomPercentageeText)
                            .font(.caption)
                            .fontWeight(.medium)
                        Text("from yesterday")
                            .foregroundColor(Color.textRegular)
                            .font(.caption)
                            .fontWeight(.light)
                    }
                    .padding(.bottom)
                    .foregroundColor(Color.green)
                }
                .padding(.top)
                .padding(.leading)
                Spacer()
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
//        .padding()
    }
}


#Preview {
    HStack{
        SecondRowView(datas: .FRT)
        SecondRowView(datas: .TTA)
        SecondRowView(datas: .TTR)
        SecondRowView(datas: .RR)
    }
    .frame(width : 305, height : 151)
//    .padding()
}
