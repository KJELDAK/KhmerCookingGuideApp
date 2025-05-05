//
//  PasswordInputation.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 12/12/24.
//

import SwiftUI

import SwiftUI

struct PasswordInputation: View {
    @State private var isPasswordVisible = false
    @Binding var password: String
    @Binding var errorMessage: String
    @Binding var isValidation: Bool

//    private let validator = ValidationPassword() // Password validator instance

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Password Input Field
            HStack {
                // Lock Icon
                Image("lock")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hex: "#757575"))

                // Password Field (SecureField or TextField based on visibility)
                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        Text("input_your_password")
                            .customFontLocalize(size: 16)
                            .foregroundColor(Color(hex: "#757575"))
                    }

                    if isPasswordVisible {
                        TextField("", text: $password)
                            .customFontLocalize(size: 16)
//                            ./*onChange(of: password, perform: validatePassword)*/
                    } else {
                        SecureField("", text: $password)
                            .customFontLocalize(size: 16)
//                            .onChange(of: password, perform: validatePassword)
                    }
                }

                Spacer()

                // Toggle Password Visibility
                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        isPasswordVisible.toggle()
                    }
            }
            .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color(hex: "#F9FAFB"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isValidation ? Color(hex: "#E5E7EB") : Color.red, lineWidth: 1)
            )

            // Error Message
            if !isValidation && !errorMessage.isEmpty {
                Text(LocalizedStringKey(errorMessage))
                    .customFontLocalize(size: 12)
                    .foregroundColor(.red)
                    .padding(.leading, 8)
            }
        }
    }

//    // MARK: - Password Validation
//    func validatePassword(_ password: String) {
//        if let validationResult = validator.validate(password) {
//            isValidation = false
//            errorMessage = validationResult
//        } else {
//            isValidation = true
//            errorMessage = ""
//        }
//    }
    // }
//
    //// MARK: - Password Validator
    // struct ValidationPassword {
//    func validate(_ password: String) -> String? {
//        if password.isEmpty {
//            return "Password is required."
//            //        } else if password.count < 8 {
//            //            return "Password must be at least 8 characters long."
//            //        } else if !containsUppercase(password) {
//            //            return "Password must contain at least one uppercase letter."
//            //        } else if !containsDigit(password) {
//            //            return "Password must contain at least one digit."
//            //        } else if !containsSpecialCharacter(password) {
//            //            return "Password must contain at least one special character (e.g., !@#$%^&*)."
//            //        }
//        }
//            else{
//                return nil // Valid password
//            }
//    }
//
//    // Helper function to check for uppercase letters
//    private func containsUppercase(_ text: String) -> Bool {
//        let uppercaseSet = CharacterSet.uppercaseLetters
//        return text.rangeOfCharacter(from: uppercaseSet) != nil
//    }
//
//    // Helper function to check for digits
//    private func containsDigit(_ text: String) -> Bool {
//        let digitSet = CharacterSet.decimalDigits
//        return text.rangeOfCharacter(from: digitSet) != nil
//    }
//
//    // Helper function to check for special characters
//    private func containsSpecialCharacter(_ text: String) -> Bool {
//        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:'\",.<>?/`~")
//        return text.rangeOfCharacter(from: specialCharacterSet) != nil
//    }
}
