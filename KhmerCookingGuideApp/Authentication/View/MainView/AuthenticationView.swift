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
    @State private var isNavigateToForgotPasswordView: Bool = false
    @State private var isShowLanguagePicker: Bool = false
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    var body: some View {
        ZStack {
            NavigationStack {
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
                .sheet(isPresented: $isShowLanguagePicker) {
                    LanguageSelectionView(showLanguageSheet: $isShowLanguagePicker)
                    /*                        .environmentObject(languageManager)*/ // passed from App level
                }

                .navigationDestination(isPresented: $isNavigateToHome) {
                    ContentView().navigationBarBackButtonHidden()
                }
                .navigationDestination(isPresented: $isNavigateToRegistration) {
                    RegistrationView().navigationBarBackButtonHidden()
                }
                .navigationDestination(isPresented: $isNavigateToForgotPasswordView) {
                    ForgetPasswordView().navigationBarBackButtonHidden()
                }
                .ignoresSafeArea(.keyboard)
                .padding(.horizontal)
            }
            if authenticationViewModel.isLoading {
                LoadingComponent()
            } else if islogInSuccess {
                SuccessAndFailedAlert(status: islogInSuccess, message: LocalizedStringKey(messageFromApi), duration: 3, isPresented: $islogInSuccess)
                    .onDisappear {
                        isNavigateToHome = true
                    }
            } else if isLogInFaild {
                SuccessAndFailedAlert(status: false, message: LocalizedStringKey(messageFromApi), duration: 3, isPresented: $isLogInFaild)
            } else {}
        }
    }

    // MARK: - Header View

    private func HeaderView() -> some View {
        VStack {
            HStack {
                Spacer()
                Image(languageManager.lang == "en" ? "usa" : "khmerLogo")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .padding(.horizontal, 16)
            }
            .onTapGesture {
                isShowLanguagePicker.toggle()
            }
            Image("logo")
                .resizable()
                .frame(width: 275, height: 150)
            Text("welcome_to_you")
                .customFontSemiBoldLocalize(size: 26)
                .padding(.top, -30)
            Text("enter_account")
                .customFontLocalize(size: 12)
                .foregroundColor(Color(hex: "757575"))
                .padding(.top, -10)
        }
    }

    // MARK: - Input Fields

    private func InputFields() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("_email")
                .customFontLocalize(size: 12)
                .foregroundColor(Color(hex: "757575"))
            InputComponent(textInput: $email, placeHolder: "example@mail.com", errorMessage: $errorMessageInEmail, isValidation: $isValidationInEmail)
            Text("_password")
                .customFontLocalize(size: 12)
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
                Text("forgot_password")
                    .underline()
                    .customFontSemiBoldLocalize(size: 12)
                    .foregroundColor(Color(hex: "0A0019"))
            }
        }
        .padding(.top, -12)
    }

    // MARK: - Login Button

    private func LoginButton() -> some View {
        ButtonComponent(action: {
            authenticationViewModel.loginUser(email: email, password: password) { success, message in
                if message == "🚫 Oops! Your email seems incorrect. Please use the format: example@gmail.com 🌈" {
                    messageFromApi = "email_invalid_format"
                } else if message == "Incorrect password!" {
                    messageFromApi = "incorrect_password"
                } else if message == "Login Successfully" {
                    messageFromApi = "login_success"
                } else {
                    messageFromApi = message ?? ""
                }
                if success {
                    islogInSuccess = true

                    print(message!)
                    profileViewModel.getUserInfo { _, _ in
                        print("get user role", HeaderToken.shared.role)
                    }
                } else {
                    isLogInFaild = true
                }
            }
        }, content: "_login")
            .disabled(!isValidation || !isValidationInEmail)
            .opacity(!isValidation || !isValidationInEmail ? 0.4 : 1)
    }

    // MARK: - Registration Link

    private func RegistrationLink() -> some View {
        HStack {
            Text("no_account")
                .customFontLocalize(size: 16)
            Button {
                isNavigateToRegistration = true
            } label: {
                Text("_register")
                    .foregroundColor(Color(hex: "primary"))
                    .customFontLocalize(size: 16)
            }
        }
    }

    // MARK: - Footer View

    private func FooterView() -> some View {
        VStack(spacing: 10) {
            Text("login_agreement")
                .multilineTextAlignment(.center)
                .customFontLocalize(size: 12)
                .foregroundColor(Color(hex: "0A0019"))
            HStack {
                Button {
                    // Add terms of service action
                } label: {
                    Text("terms_of_service")
                        .underline()
                        .customFontLocalize(size: 12)
                        .foregroundColor(Color(hex: "primary"))
                }
                Text("_and")
                    .customFontLocalize(size: 12)
                    .foregroundColor(Color(hex: "0A0019"))
                Button {
                    // Add privacy policy action
                } label: {
                    Text("_privacy")
                        .underline()
                        .customFontLocalize(size: 12)
                        .foregroundColor(Color(hex: "primary"))
                }
            }
        }
    }
}

#Preview {
    AuthenticationView()
}
