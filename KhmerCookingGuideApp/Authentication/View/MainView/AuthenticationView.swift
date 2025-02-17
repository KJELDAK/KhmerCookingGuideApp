//
//  AuthenticationView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/12/24.
//

import SwiftUI
struct AuthenticationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isValidation = true
    @State private var messageFromApi: String = ""
    @State private var errorMessageInEmail: String = ""
    @State private var isValidationInEmail = true
    @State private var islogInSuccess: Bool = false
    @State private var isLogInFaild: Bool = false
    @State private var isNavigateToHome: Bool = false
    @State private var isNavigateToRegistration: Bool = false
    @State private var isNavigateToForgotPasswordView : Bool = false
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    var body: some View {
        ZStack{
            NavigationStack{
                VStack {
                    HeaderView()
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            InputFields()
                            LoginButton()
                           
                        }
                        RegistrationLink()
                    }
                    .scrollDisabled(true)
                    FooterView()
                }
                .navigationDestination(isPresented: $isNavigateToHome) {
                        ContentView().navigationBarBackButtonHidden()
                    
                }
                .navigationDestination(isPresented: $isNavigateToRegistration){
                    RegistrationView().navigationBarBackButtonHidden()
                }
                .navigationDestination(isPresented: $isNavigateToForgotPasswordView){
                    ForgetPasswordView().navigationBarBackButtonHidden()
                }
                .ignoresSafeArea(.keyboard)
                .padding(.horizontal)
            }
            if authenticationViewModel.isLoading{
                LoadingComponent()
            }
            else if islogInSuccess{
                SuccessAndFailedAlert(status: islogInSuccess, message: messageFromApi , duration: 3, isPresented: $islogInSuccess)
                    .onDisappear{
                        isNavigateToHome = true
                    }
            }
            else if isLogInFaild{
                SuccessAndFailedAlert(status: false, message: messageFromApi , duration: 3, isPresented: $isLogInFaild)
            }
            else{}
        }
    }
    
    // MARK: - Header View
    private func HeaderView() -> some View {
        VStack {
            HStack {
                Spacer()
                Image("english")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .padding(.horizontal, 16)
            }
            Image("logo")
                .resizable()
                .frame(width: 275, height: 150)
            Text("Welcome to you")
                .customFontRobotoBold(size: 26)
                .padding(.top, -30)
            Text("Please enter your account here")
                .customFontRobotoRegular(size: 12)
                .foregroundColor(Color(hex: "757575"))
                .padding(.top, -10)
        }
    }
    
    // MARK: - Input Fields
    private func InputFields() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Email")
                .customFont(size: 12)
                .foregroundColor(Color(hex: "757575"))
            InputComponent(textInput: $email, placeHolder: "example@mail.com", errorMessage: $errorMessageInEmail, isValidation: $isValidationInEmail)
            Text("Password")
                .customFont(size: 12)
                .foregroundColor(Color(hex: "757575"))
            PasswordInputationComponent(password: $password, errorMessage: $errorMessage, isValidation: $isValidation)
                .padding(.top, -12)
            ForgotPasswordLink()
        }
    }
    
    // MARK: - Forgot Password Link
    private func ForgotPasswordLink() -> some View {
        HStack {
            Spacer()
            Button {
                isNavigateToForgotPasswordView = true
            } label: {
                Text("Forgot Password")
                    .underline()
                    .customFontBold(size: 12)
                    .foregroundColor(Color(hex: "0A0019"))
            }
        }
        .padding(.top, -12)
    }
    
    // MARK: - Login Button
    private func LoginButton() -> some View {
        ButtonComponent(action: {
            authenticationViewModel.loginUser(email: email, password: password ){ success, message in
                if success {
                    islogInSuccess = true
                    messageFromApi = message ?? ""
                    print(message!)
                    profileViewModel.getUserInfo { success, message in
                        print("get user role", HeaderToken.shared.role)
                    }
                }
                else{
                    isLogInFaild = true
                    messageFromApi = message ?? ""
                }
            }
        }, content: "Login")
        .disabled(!isValidation || !isValidationInEmail)
        .opacity(!isValidation  || !isValidationInEmail ? 0.4 : 1)
    }
    
    // MARK: - Registration Link
    private func RegistrationLink() -> some View {
        HStack {
            Text("Don't have an account?")
            Button {
                isNavigateToRegistration = true
            } label: {
                Text("Register")
                    .foregroundColor(Color(hex: "primary"))
            }
        }
    }
    
    // MARK: - Footer View
    private func FooterView() -> some View {
        VStack(spacing: 10) {
            Text("By clicking “ LOGIN “ you agreed to our ")
                .multilineTextAlignment(.center)
                .customFont(size: 12)
                .foregroundColor(Color(hex: "0A0019"))
            HStack {
                Button {
                    // Add terms of service action
                } label: {
                    Text("Terms of Service ")
                        .underline()
                        .customFont(size: 12)
                        .foregroundColor(Color(hex: "primary"))
                }
                Text("and")
                    .customFont(size: 12)
                    .foregroundColor(Color(hex: "0A0019"))
                Button {
                    // Add privacy policy action
                } label: {
                    Text("Privacy")
                        .underline()
                        .customFont(size: 12)
                        .foregroundColor(Color(hex: "primary"))
                }
            }
        }
    }
}

#Preview {
    AuthenticationView()
}
