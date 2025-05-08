//
//  CreatePasswordView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 11/12/24.
//

import SwiftUI

struct CreatePasswordView: View {
    @State var newPassword: String = ""
    @State var newPasswordErrorMessage: String = ""
    @State var isValidationNewPassword: Bool = true
    @State var confirmPassword: String = ""
    @State var confirmPasswordErrorMessage: String = ""
    @State var isValidationConfirmPassword: Bool = true
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State var isNavigateToLoginView: Bool = false
    @State var isCreatePasswordSuccess: Bool = false
    @State var isCreatePasswordFailed: Bool = false
    @State var messageFromAPI: String = ""
    @Binding var email: String
    @Binding var isRegister: Bool
    @State var isNavigateToAddUserInfoView: Bool = false
    @Environment(\.dismiss) var dissmiss

    // Validate Passwords
    private func validatePasswords() -> Bool {
        var isValid = true

        if newPassword.isEmpty {
            newPasswordErrorMessage = "enter_new_password"
            isValidationNewPassword = false
            isValid = false
        } else {
            isValidationNewPassword = true
        }

        if confirmPassword.isEmpty {
            confirmPasswordErrorMessage = "enter_confirm_password"
            isValidationConfirmPassword = false
            isValid = false
        } else if newPassword != confirmPassword {
            confirmPasswordErrorMessage = "passwords_do_not_match"
            isValidationConfirmPassword = false
            isValid = false
        } else {
            isValidationConfirmPassword = true
        }

        return isValid
    }

    var body: some View {
        ZStack {
            NavigationView {
                VStack(alignment: .leading) {
                    Text("create_new_password")
                        .customFontSemiBoldLocalize(size: 18)
                    HStack {
                        Text("new_password")
                            .customFontMediumLocalize(size: 16)
                            .foregroundColor(Color(hex: "0A0019"))
                        Text("*").foregroundColor(Color(hex: "primary"))
                    }
                    .padding(.top)
                    PasswordInputation(password: $newPassword, errorMessage: $newPasswordErrorMessage, isValidation: $isValidationNewPassword)
                        .onChange(of: newPassword) { _ in
                            _ = validatePasswords()
                        }
                        .padding(.top, -10)

                    HStack {
                        Text("confirm_new_password")
                            .customFontMediumLocalize(size: 16)
                            .foregroundColor(Color(hex: "0A0019"))
                        Text("*").foregroundColor(Color(hex: "primary"))
                    }
                    .padding(.top)
                    PasswordInputation(password: $confirmPassword, errorMessage: $confirmPasswordErrorMessage, isValidation: $isValidationConfirmPassword)
                        .padding(.top, -10)
                        .onChange(of: confirmPassword) { _ in
                            _ = validatePasswords()
                        }
                    ButtonComponent(action: {
                        if newPassword == confirmPassword {
                            if isRegister {
                                authenticationViewModel.createPassword(email: email, password: confirmPassword) { isSuccess, message in
                                    messageFromAPI = message
                                    switch messageFromAPI {
                                    case "Password created successfully":
                                        messageFromAPI = "password_created_successfully"
                                    default:
                                        messageFromAPI = message
                                    }
                                    if isSuccess {
                                        isCreatePasswordSuccess = true

                                    } else {
                                        isCreatePasswordFailed = true
                                    }
                                }
                            } else {
                                print(HeaderToken.shared.token)
                                authenticationViewModel.createPassword(email: email, password: confirmPassword) { isSuccess, message in
                                    messageFromAPI = message
                                    if isSuccess {
                                        isCreatePasswordSuccess = true
                                    } else {
                                        isCreatePasswordFailed = true
                                    }
                                }
                            }
                        } else {
                            confirmPasswordErrorMessage = "passwords_do_not_match"

                            isValidationConfirmPassword = false
                        }

                    }, content: "_next").padding(.top)
                        .disabled(!isValidationConfirmPassword)
                        .opacity(isValidationNewPassword && isValidationConfirmPassword ? 1 : 0.5)

                    Spacer()
                }

                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dissmiss()
                        }) {
                            Image("backButton")
                        }
                    }
                }
                .navigationDestination(isPresented: $isNavigateToAddUserInfoView) {
                    AdditionalInformationView().navigationBarBackButtonHidden(true)
                }
            }
            SuccessAndFailedAlert(status: true, message: LocalizedStringKey(messageFromAPI), duration: 3, isPresented: $isCreatePasswordSuccess)
                .onDisappear {
                    if isRegister {
                        // dfghjk
                        isNavigateToAddUserInfoView = true
                    } else {
                        isNavigateToLoginView = true
                    }
                }
            SuccessAndFailedAlert(status: false, message: LocalizedStringKey(messageFromAPI), duration: 3, isPresented: $isCreatePasswordFailed)
        }
        .fullScreenCover(isPresented: $isNavigateToLoginView) {
            AuthenticationView()
        }
    }
}
