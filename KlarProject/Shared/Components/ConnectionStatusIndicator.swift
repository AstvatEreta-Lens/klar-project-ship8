//
//  ConnectionStatusIndicator.swift
//  KlarProject
//
//  Status indicator component for connection status
//

import SwiftUI

struct ConnectionStatusIndicator: View {
    let status: ConnectionStatus
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)
            
            Text(status.text)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(status.color.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 16) {
        ConnectionStatusIndicator(status: .connected)
        ConnectionStatusIndicator(status: .serverConnected)
        ConnectionStatusIndicator(status: .connecting)
        ConnectionStatusIndicator(status: .disconnected)
    }
    .padding()
}

