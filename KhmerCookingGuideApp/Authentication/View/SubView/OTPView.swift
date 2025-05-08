//
//  OTPView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 11/12/24.
//

import Combine
import SwiftUI

// Main View for OTP fields
struct OTPView: View {
    @Binding var email: String
    enum FocusPin {
        case pinOne, pinTwo, pinThree, pinFour, pinFive, pinSix
    }

    @FocusState private var pinFocusState: FocusPin?
    @State private var pinOne = ""
    @State private var pinTwo = ""
    @State private var pinThree = ""
    @State private var pinFour = ""
    @State private var pinFive = ""
    @State private var pinSix = ""
    @State private var resendEnabled = false // To track resend button state
    @State private var messageFromAPI: String = ""
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State private var timerValue = 120 // Timer countdown value in seconds
    @State private var timerCancellable: AnyCancellable? // For managing the timer
    @State var isOTPvalid: Bool = false
    @State var isOTPNotValid: Bool = false
    var isOTPComplete: Bool {
        [pinOne, pinTwo, pinThree, pinFour, pinFive, pinSix].allSatisfy { $0.count == 1 }
    }

    @Environment(\.dismiss) var dismiss
    // Start the timer
    @State var isNavigationToCreatePasswordView: Bool = false
    private func startTimer() {
        resendEnabled = false
        timerValue = 120 // Reset timer to 2 minutes
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timerValue > 0 {
                    timerValue -= 1
                } else {
                    timerCancellable?.cancel()
                    resendEnabled = true
                }
            }
    }

    @Binding var isRegister: Bool

    // Verify OTP Action
    private func verifyOtp() -> String {
        // Logic to verify OTP
        return pinOne + pinTwo + pinThree + pinFour + pinFive + pinSix
    }

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 100)
                        Image("amok")
                            .resizable()
                            .scaledToFit()
                    }
                    .padding(.top, -40)
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("verification_code")
                                .customFontMediumLocalize(size: 22)
                                .fontWeight(.semibold)
                            Group {
                                Text("enter_otp_message")

                                Text(email)
                            }

                            .customFontLocalize(size: 13)
                        }
                        .padding(.leading)
                        Spacer()
                    }

                    // OTP Input Fields
                    HStack(spacing: 15) {
                        otpTextField(text: $pinOne, focus: .pinOne, nextFocus: .pinTwo)
                        otpTextField(text: $pinTwo, focus: .pinTwo, nextFocus: .pinThree, prevFocus: .pinOne)
                        otpTextField(text: $pinThree, focus: .pinThree, nextFocus: .pinFour, prevFocus: .pinTwo)
                        otpTextField(text: $pinFour, focus: .pinFour, nextFocus: .pinFive, prevFocus: .pinThree)
                        otpTextField(text: $pinFive, focus: .pinFive, nextFocus: .pinSix, prevFocus: .pinFour)
                        otpTextField(text: $pinSix, focus: .pinSix, prevFocus: .pinFive)
                    }
                    .padding(.vertical)

                    if resendEnabled {
                        Button("resend_code") {
                            startTimer()
                            authenticationViewModel.sendOTP(email: email) { isSuccess, _ in
                                if isSuccess {}
                            }
                        }
                        .customFontLocalize(size: 14)
                        .foregroundColor(.blue)
                    } else {
                        HStack {
                            Text("resend_in")
                            Text("\(String(format: "%02d:%02d", timerValue / 60, timerValue % 60))")
                        }
                        .foregroundColor(.gray)
                        .customFontLocalize(size: 14)
                    }
                    ButtonComponent(action: {
                        let otp = verifyOtp()
                        authenticationViewModel.verifyOTP(email: email, otp: otp) { isSuccess, message in
                            messageFromAPI = message
                            switch message {
                            case "Invalid OTP format [6 digits only].":
                                messageFromAPI = "invalid_OTP_format"
                            case "Invalid OTP provided.":
                                messageFromAPI = "invalid_otp_provided"
                            case"OTP validated and email verified successfully":
                                messageFromAPI = "otp_validated_and_email_verified"
                            default:
                                messageFromAPI = message
                            }
                            print(message)
                            if isSuccess {
                                isOTPvalid = true
                            } else {
                                isOTPNotValid = true
                            }
                        }
                    }, content: "_continue")
                        .disabled(!isOTPComplete)
                        .opacity(isOTPComplete ? 1.0 : 0.5)
                        .padding()

                    Spacer()
                }
                .navigationDestination(isPresented: $isNavigationToCreatePasswordView, destination: {
                    CreatePasswordView(authenticationViewModel: authenticationViewModel, email: $email, isRegister: $isRegister).navigationBarBackButtonHidden(true)
                })
                .onAppear {
                    pinFocusState = .pinOne // Focus on the first field on appear
                    startTimer() // Start timer on appear
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("backButton")
                        }
                    }
                }

                //            Spacer()
            }

            if isOTPvalid {
                SuccessAndFailedAlert(status: true, message: LocalizedStringKey(messageFromAPI), duration: 3, isPresented: $isOTPvalid)
                    .onDisappear {
                        isNavigationToCreatePasswordView = true
                    }
            } else if isOTPNotValid {
                SuccessAndFailedAlert(status: false, message: LocalizedStringKey(messageFromAPI), duration: 3, isPresented: $isOTPNotValid)
            }
        }
    }

    // Reusable OTP text field with focus management
    private func otpTextField(text: Binding<String>, focus: FocusPin, nextFocus: FocusPin? = nil, prevFocus: FocusPin? = nil) -> some View {
        TextField("", text: text)
            .modifier(OTPModifier(pin: text, isFocused: pinFocusState == focus))
            .onChange(of: text.wrappedValue) { newValue in
                if newValue.count == 1 {
                    if let next = nextFocus {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            pinFocusState = next
                        }
                    }
                } else if newValue.isEmpty, let prev = prevFocus {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        pinFocusState = prev
                    }
                }
            }
            .focused($pinFocusState, equals: focus)
            .onReceive(Just(text.wrappedValue)) { _ in
                if text.wrappedValue.count > 1 {
                    text.wrappedValue = String(text.wrappedValue.prefix(1))
                }
            }
    }
}

// Modifier for limiting input and styling text fields
struct OTPModifier: ViewModifier {
    @Binding var pin: String
    var textLimit: Int = 1
    var isFocused: Bool // Added to handle focus state

    func limitText(_ upper: Int) {
        if pin.count > upper {
            pin = String(pin.prefix(upper))
        }
    }

    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) { _ in limitText(textLimit) }
            .frame(width: 45, height: 45)
            .background(Color(hex: "000000").cornerRadius(14).opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isFocused ? Color.blue : Color(hex: "000000").opacity(0.05), lineWidth: 2) // Change color based on focus
            )
    }
}
