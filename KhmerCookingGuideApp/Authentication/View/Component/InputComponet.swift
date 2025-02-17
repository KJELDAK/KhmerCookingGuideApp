//
//  InputComponet.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/12/24.
//

import SwiftUI

struct InputComponent: View {
    @Binding var textInput:String
    @State var placeHolder : /*LocalizedStringKey*/ String
    @Binding var errorMessage: String
    @Binding var isValidation:Bool
    
    // Create an instance of the EmailValidator
    private let validator = ValidationEmail()
    
    // Function to validate the password using the PasswordValidator
    func validateEmail(_ email: String) {
        if let validationResult = validator.validate(email) {
            isValidation = false
            errorMessage = validationResult
        } else {
            isValidation = true
            errorMessage = ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image("emailePlaceholder")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hex: "#374957"))
                
                ZStack(alignment: .leading) {
                    if textInput.isEmpty {
                        Text(placeHolder)
                            .customFont(size: 16)
                            .foregroundColor(Color(hex: "#757575"))
                    }
                    TextField("", text: $textInput)
                        .customFont(size: 20)
                        .multilineTextAlignment(.leading)
                        .onChange(of: textInput){
//                            newValue in
                            validateEmail(textInput)
                        }
                }
            }
            .frame( maxWidth: .infinity,minHeight: 36, maxHeight: 36)
            .padding(.horizontal,15)
            .padding(.vertical, 10)
            .background(Color(hex: "#F9FAFB"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isValidation ? Color(hex: "#E5E7EB") : Color.red, lineWidth: 1)
            )
            // Error Message
            if !isValidation && !errorMessage.isEmpty {
                Text(errorMessage)
                    .customFont(size: 12)
                    .foregroundColor(.red)
                    .padding(.leading, 8)
            }
        }
    }
}

struct ValidationEmail {
    
    func validate(_ email: String) -> String? {
        if email.isEmpty {
            return "email is empty."
        }
        else {
            return nil
        }
    }
    // Email validation using regex
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

