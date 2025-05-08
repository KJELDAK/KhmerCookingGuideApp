//
//  OTPView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 11/12/24.
//
import SwiftUI

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var messageFromApi: String = ""
    @State private var errorMessageInEmail: String = ""
    @State private var isValidationInEmail = true
    @State private var isEmailExist: Bool = false
    @State private var isEmailNotExist: Bool = false
    @State private var isNavigateToLogin: Bool = false
    @State private var isNavigateToOTPView: Bool = false
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @State var isEmailNotCorrectFomart: Bool = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HeaderView()
                        .padding(.bottom, 32)
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
                .navigationDestination(isPresented: $isNavigateToOTPView) {
                    OTPView(email: $email, authenticationViewModel: authenticationViewModel, isRegister: .constant(true)).navigationBarBackButtonHidden(true)
                }
                .ignoresSafeArea(.keyboard)
                .padding(.horizontal)
            }

            if authenticationViewModel.isLoading {
                LoadingComponent()
            } else if isEmailExist {
                SuccessAndFailedAlert(status: false, message: LocalizedStringKey("email_already_registered"),
                                      duration: 3, isPresented: $isEmailExist)
            } else if isEmailNotCorrectFomart {
                SuccessAndFailedAlert(status: false, message: LocalizedStringKey("email_invalid_format"), duration: 3, isPresented: $isEmailNotCorrectFomart)
            }
        }
        .onAppear {
            print(recipeViewModel.isLoading)
        }
    }

    // MARK: - Header View

    private func HeaderView() -> some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 275, height: 150)
            Text("register_title")
                .customFontSemiBoldLocalize(size: 26)
                .padding(.top, -30)
            Text("register_subtitle")
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
                messageFromApi = message
                if isSuccess {
                    print("success", message)
                    isEmailExist = true
                } else {
                    print("min success ", message)
                    if message == "🚫 Oops! Your email seems incorrect. Please use the format: example@gmail.com 🌈" {
                        isNavigateToOTPView = false
                        isEmailNotCorrectFomart = true
                    } else {
                        authenticationViewModel.sendOTP(email: email) { isSuccess, message in
                            if isSuccess {
                                print("success", message)
                            } else {
                                print("min success", message)
                            }
                        }
                        isNavigateToOTPView = true
                        isEmailNotExist = true
                    }
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
                    .customFontLocalize(size: 16)
                    .foregroundColor(Color(hex: "primary"))
            }
        }
    }

    // MARK: - Footer View

    private func FooterView() -> some View {
        VStack(spacing: 10) {
            Text("register_footer_line_1")
                .multilineTextAlignment(.center)
                .customFontLocalize(size: 12)
                .foregroundColor(Color(hex: "0A0019"))
            Text("register_footer_line_2")
                .multilineTextAlignment(.center)
                .customFontLocalize(size: 12)
                .foregroundColor(Color(hex: "0A0019"))
        }
    }
}

#Preview {
    RegistrationView()
}
