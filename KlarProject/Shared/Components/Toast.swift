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
    case info, error, alert, success
    
    var backgroundColor: Color {
        switch self {
        case .info: return Color.secondaryText
        case .error: return Color.white
        case .alert: return Color.white
        case .success: return Color.white
        }
    }
    
    var textColor: Color {
        switch self {
        case .info: return .white
        case .error, .alert, .success: return .black
        }
    }
    
    var titleColor: Color {
        switch self {
        case .info: return .white
        case .error: return Color.redStatus
        case .alert: return Color.redStatus
        case .success: return Color.greenStatus
        }
    }
    
    var borderColor: Color {
        switch self {
        case .info: return Color.sectionHeader
        case .error: return Color.redStatus
        case .alert: return Color.redStatus
        case .success: return Color.greenStatus
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .info: return Color.sectionHeader
        case .error: return Color.redStatus
        case .alert: return Color.yellowStatus
        case .success: return Color.greenStatus
        }
    }
}

enum PredefinedToast {
//    case infoWithButton
//    case infoWithoutButton
//    case errorWithButton
//    case errorWithoutButton
//    case warningWithButton
//    case warningWithoutButton
//    case successWithButton
//    case successWithoutButton
//    case evaluationSuccess
//    case evaluationError
    
    
    // MARK: Used Toast to recent workflow
    
//    case alertUnableToOpenConversation
    case alertConvoNotAvailable
    case errorFailedToGenerateSuggestion
    case networkErrorToTakeOver
    case networkErrorfailedToAddNote
    case networkErrorCouldntGenerateSummary
    case conversationSuccessfullyEvaluated
    case networkErrorFailedToCreateKBDraft
    case networkErrorUploadKBFailed
    case successUpdateLabel
    case errorToEvaluateConversation
    case successEvaluateConversation

    var config: ToastConfig {
        switch self {
//        case .infoWithButton:
//            return ToastConfig(
//                type: .info,
//                title: "Toast Title",
//                message: "Unable to open conversation, please try again.",
//                hasButton: true
//            )
//        case .infoWithoutButton:
//            return ToastConfig(
//                type: .info,
//                title: "Toast Title",
//                message: "Unable to open conversation, please try again.",
//                hasButton: false
//            )
//        case .errorWithButton:
//            return ToastConfig(
//                type: .error,
//                title: "Toast Title",
//                message: "Unable to open conversation, please try again.",
//                hasButton: true
//            )
//        case .errorWithoutButton:
//            return ToastConfig(
//                type: .error,
//                title: "Toast Title",
//                message: "Unable to open conversation, please try again.",
//                hasButton: false
//            )
//        case .warningWithButton:
//            return ToastConfig(
//                type: .warning,
//                title: "Toast Title",
//                message: "Unable to open conversation, please try again.",
//                hasButton: true
//            )
//        case .warningWithoutButton:
//            return ToastConfig(
//                type: .warning,
//                title: "Toast Title",
//                message: "Unable to open conversation, please try again.",
//                hasButton: false
//            )
//        case .successWithButton:
//            return ToastConfig(
//                type: .success,
//                title: "Toast Title",
//                message: "Unable to open conversation, please try again.",
//                hasButton: true
//            )
//        case .successWithoutButton:
//            return ToastConfig(
//                type: .success,
//                title: "Toast Title",
//                message: "Unable to open conversation, please try again.",
//                hasButton: false
//            )
//        case .evaluationSuccess:
//            return ToastConfig(
//                type: .success,
//                title: "Success",
//                message: "Conversation has been sent to evaluation page.",
//                hasButton: false
//            )
//        case .evaluationError:
//            return ToastConfig(
//                type: .error,
//                title: "Error",
//                message: "Conversation must be resolved before evaluation.",
//                hasButton: false
//            )
        case .alertConvoNotAvailable:
            return ToastConfig(
                type : .alert,
                title : "Alert",
                message : "Unable to open conversation, please try again later.",
                hasButton: false
                )
            
        case .errorFailedToGenerateSuggestion:
            return ToastConfig(
                type : .error,
                title : "Error",
                message : "Failed to generate suggestion.",
                hasButton: false
            )
            
        case .networkErrorToTakeOver:
            return ToastConfig(
                type : .error,
                title : "Error",
                message : "Failed to takeover, please try again.",
                hasButton: false
            )
            
        case .networkErrorfailedToAddNote:
            return ToastConfig(
                type : .error,
                title : "Error",
                message : "Failed to add note. Please try again.",
                hasButton: false
            )
            
        case .networkErrorCouldntGenerateSummary:
            return ToastConfig(
                type : .error,
                title : "AI Error",
                message : "Failed to generate suggestion. Please try again.",
                hasButton: false
            )
            
        case .conversationSuccessfullyEvaluated:
            return ToastConfig(
                type : .success,
                title : "Success",
                message : "Conversation successfully evaluated.",
                hasButton: false
            )
            
        case .networkErrorFailedToCreateKBDraft:
            return ToastConfig(
                type : .error,
                title : "Network Error",
                message : "Failed to create KB draft. Please try again.",
                hasButton: false
            )
            
        case .networkErrorUploadKBFailed:
            return ToastConfig(
                type : .error,
                title : "Network Error",
                message : "Upload failed. Please check your connection and try again.",
                hasButton: false
            )
            
        case .successUpdateLabel:
            return ToastConfig(
                type : .success,
                title : "Success",
                message : "Successfully to update label.",
                hasButton: false
            )
        case .errorToEvaluateConversation:
            return ToastConfig(
                type : .error,
                title : "Error",
                message : "Cannot evaluate conversation. Please try again.",
                hasButton: false
            )
        case .successEvaluateConversation:
            return ToastConfig(
                type : .success,
                title : "Success",
                message : "Successfully to evaluate conversation",
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
            Button("Alert Conversation Not Available") {
                toastManager.show(.alertConvoNotAvailable) {
                    print("Info button tapped")
                }
            }
            
            Button("Conversation successfully evaluated") {
                toastManager.show(.conversationSuccessfullyEvaluated) {
                    print("Info button tapped")
                }
            }
        }
        .toast(manager: toastManager)
    }
}


#Preview {
    ToastFinalView()
        .frame(width : 400)
}
