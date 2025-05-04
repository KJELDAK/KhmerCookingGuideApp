//
//  ForgetPasswordView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 15/12/24.
//

import SwiftUI

//struct ForgetPasswordView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    ForgetPasswordView()
//}
//
//  OTPView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 11/12/24.
//
import SwiftUI
struct ForgetPasswordView: View {
    @State private var email: String = ""
    @State private var messageFromApi: String = ""
    @State private var errorMessageInEmail: String = ""
    @State private var isValidationInEmail = true
    @State private var isEmailExist: Bool = false
    @State private var isEmailNotExist: Bool = false
    @State private var isNavigateToLogin: Bool = false
    @State private var isNavigateToOTPView: Bool = false
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HeaderView()
                        .padding(.bottom,32)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            InputFields()
                            LoginButton()
                        }
                        BackToLoginLink()
                    }
                    .scrollDisabled(true)
                    FooterView()
                }
                .navigationDestination(isPresented: $isNavigateToOTPView){
                    OTPView(email: $email,authenticationViewModel: authenticationViewModel,isRegister: .constant(false)).navigationBarBackButtonHidden(true)
                }
                .ignoresSafeArea(.keyboard)
                .padding(.horizontal)
            }
            
            if authenticationViewModel.isLoading {
                LoadingComponent()
            }
            else if isEmailNotExist{
                SuccessAndFailedAlert(status: false, message: LocalizedStringKey(messageFromApi), duration: 3, isPresented: $isEmailNotExist)
            }
        }
    }
    
    // MARK: - Header View
    private func HeaderView() -> some View {
        VStack {
      
            Image("logo")
                .resizable()
                .frame(width: 275, height: 150)
            Text("forgot_password_title")
                .customFontSemiBoldLocalize(size: 26)
                .padding(.top, -30)
            Text("forgot_password_message")
                .customFontLocalize(size: 12)
                .foregroundColor(Color(hex: "757575"))
                .padding(.top, -10)
        }
    }
    
    // MARK: - Input Fields
    private func InputFields() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("_email")
                .customFont(size: 12)
                .foregroundColor(Color(hex: "757575"))
            InputComponent(textInput: $email, placeHolder: "example@mail.com", errorMessage: $errorMessageInEmail, isValidation: $isValidationInEmail)
                .padding(.bottom)
        }
    }
    
    // MARK: - Next Button
    private func LoginButton() -> some View {
        ButtonComponent(action: {
            authenticationViewModel.CheckEmailExists(email: email) { isSuccess, message in
              
               
                switch message{
                case "🚫 Oops! Your email seems incorrect. Please use the format: example@gmail.com 🌈":
                    messageFromApi = "email_invalid_format"
              
                default:
                    messageFromApi = message
                }
                if isSuccess{
                    isNavigateToOTPView = true
                    isEmailExist = true
                    authenticationViewModel.sendOTP(email: email) { isSuccess, message in
                            print(message)
                    }
                }
                else {
                    isEmailNotExist = true
                }
            }
//            isNavigateToOTPView = true
        }, content: "_next")
        .disabled(!isValidationInEmail)
        .opacity(!isValidationInEmail ? 0.4 : 1)
    }
    // MARK: - Back to Login Link
    private func BackToLoginLink() -> some View {
        HStack {
            Text("_back_to")
                .customFontLocalize(size: 16)
            Button {
                dismiss()
            } label: {
                Text("Login?")
                    .foregroundColor(Color(hex: "primary"))
                    .customFontLocalize(size: 16)
            }
        }
    }
    // MARK: - Footer View
    private func FooterView() -> some View {
        VStack(spacing: 10) {
            Text("discover_cook_share")
                .multilineTextAlignment(.center)
                .customFontLocalize(size: 12)
                .foregroundColor(Color(hex: "0A0019"))
            Text("sign_up_start_cooking")
                .multilineTextAlignment(.center)
                .customFontLocalize(size: 12)
                .foregroundColor(Color(hex: "0A0019"))
        }
    }
}

#Preview {
    ForgetPasswordView()
}
