//
//  Toast.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 14/11/25.
//

import SwiftUI


struct ToastConfig {
    let type: ToastType
    let title: String
    let message: String
    let hasButton: Bool
}

enum ToastType {
    case info, error, warning, success
    
    var backgroundColor: Color {
        switch self {
        case .info: return Color.secondaryText
        case .error: return Color.white
        case .warning: return Color.white
        case .success: return Color.white
        }
    }
    
    var textColor: Color {
        switch self {
        case .info: return .white
        case .error, .warning, .success: return .black
        }
    }
    
    var titleColor: Color {
        switch self {
        case .info: return .white
        case .error: return Color.redStatus
        case .warning: return Color.yellowStatus
        case .success: return Color.greenStatus
        }
    }
    
    var borderColor: Color {
        switch self {
        case .info: return Color.sectionHeader
        case .error: return Color.redStatus
        case .warning: return Color.yellowStatus
        case .success: return Color.greenStatus
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .info: return Color.sectionHeader
        case .error: return Color.redStatus
        case .warning: return Color.yellowStatus
        case .success: return Color.greenStatus
        }
    }
}

enum PredefinedToast {
    case infoWithButton
    case infoWithoutButton
    case errorWithButton
    case errorWithoutButton
    case warningWithButton
    case warningWithoutButton
    case successWithButton
    case successWithoutButton
    case evaluationSuccess
    case evaluationError

    var config: ToastConfig {
        switch self {
        case .infoWithButton:
            return ToastConfig(
                type: .info,
                title: "Toast Title",
                message: "Unable to open conversation, please try again.",
                hasButton: true
            )
        case .infoWithoutButton:
            return ToastConfig(
                type: .info,
                title: "Toast Title",
                message: "Unable to open conversation, please try again.",
                hasButton: false
            )
        case .errorWithButton:
            return ToastConfig(
                type: .error,
                title: "Toast Title",
                message: "Unable to open conversation, please try again.",
                hasButton: true
            )
        case .errorWithoutButton:
            return ToastConfig(
                type: .error,
                title: "Toast Title",
                message: "Unable to open conversation, please try again.",
                hasButton: false
            )
        case .warningWithButton:
            return ToastConfig(
                type: .warning,
                title: "Toast Title",
                message: "Unable to open conversation, please try again.",
                hasButton: true
            )
        case .warningWithoutButton:
            return ToastConfig(
                type: .warning,
                title: "Toast Title",
                message: "Unable to open conversation, please try again.",
                hasButton: false
            )
        case .successWithButton:
            return ToastConfig(
                type: .success,
                title: "Toast Title",
                message: "Unable to open conversation, please try again.",
                hasButton: true
            )
        case .successWithoutButton:
            return ToastConfig(
                type: .success,
                title: "Toast Title",
                message: "Unable to open conversation, please try again.",
                hasButton: false
            )
        case .evaluationSuccess:
            return ToastConfig(
                type: .success,
                title: "Success",
                message: "Conversation has been sent to evaluation page.",
                hasButton: false
            )
        case .evaluationError:
            return ToastConfig(
                type: .error,
                title: "Error",
                message: "Conversation must be resolved before evaluation.",
                hasButton: false
            )
        }
    }
}


class ToastManager: ObservableObject {
    @Published var currentToast: PredefinedToast?
    @Published var buttonAction: (() -> Void)?
    
    // panggil dengan toast type
    func show(_ toast: PredefinedToast, buttonAction: (() -> Void)? = nil, duration: Double = 3.0) {
        self.currentToast = toast
        self.buttonAction = buttonAction
        
        // Auto dismiss jika gaada view button
        if !toast.config.hasButton {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.dismiss()
            }
        }
    }
    
    func dismiss() {
        withAnimation {
            currentToast = nil
            buttonAction = nil
        }
    }
}


struct ToastView: View {
    let config: ToastConfig
    let buttonAction: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(config.title)
                    .font(.headline)
                    .foregroundColor(config.type.titleColor)
                
                Text(config.message)
                    .font(.subheadline)
                    .foregroundColor(config.type.textColor)
            }
            
            Spacer()
            
            if config.hasButton {
                Button(action: {
                    buttonAction?()
                }) {
                    Text("View")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(config.type.buttonColor)
                        .cornerRadius(20)
                }
                
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(16)
        .background(config.type.backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(config.type.borderColor, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}


// Modifier animasi
struct ToastModifier: ViewModifier {
    @ObservedObject var toastManager: ToastManager
    
    func body(content: Content) -> some View {
        ZStack(alignment : .topTrailing) {
            content
            
            VStack {
                if let toast = toastManager.currentToast {
                    ToastView(
                        config: toast.config,
                        buttonAction: toastManager.buttonAction
                    )
                    .frame(maxWidth: 350)
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onTapGesture {
                        toastManager.dismiss()
                    }
                }
                
                Spacer()
            }
            .animation(.spring(), value: toastManager.currentToast != nil)
        }
    }
}

extension View {
    func toast(manager: ToastManager) -> some View {
        modifier(ToastModifier(toastManager: manager))
    }
}


struct ToastFinalView: View {
    @StateObject private var toastManager = ToastManager()
    
    var body: some View {
        VStack(spacing: 20) {
            // Info Toasts
            Button("Show Info with Button") {
                toastManager.show(.infoWithButton) {
                    print("Info button tapped")
                }
            }
            
            Button("Show Info without Button") {
                toastManager.show(.infoWithoutButton)
            }
            
            // Error Toasts
            Button("Show Error with Button") {
                toastManager.show(.errorWithButton) {
                    print("Error button tapped")
                }
            }
            
            Button("Show Error without Button") {
                toastManager.show(.errorWithoutButton)
            }
            
            // Warning Toasts
            Button("Show Warning with Button") {
                toastManager.show(.warningWithButton) {
                    print("Warning button tapped")
                }
            }
            
            Button("Show Warning without Button") {
                toastManager.show(.warningWithoutButton)
            }
            
            // Success Toasts
            Button("Show Success with Button") {
                toastManager.show(.successWithButton) {
                    print("Success button tapped")
                }
            }
            
            Button("Show Success without Button") {
                toastManager.show(.successWithoutButton)
            }
        }
        .toast(manager: toastManager)
    }
}


#Preview {
    ToastFinalView()
        .frame(width : 400)
}
