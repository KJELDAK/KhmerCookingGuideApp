//
//  AdditionalInformationView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 11/12/24.
//

import SwiftUI

struct AdditionalInformationView: View {
    @Environment(\.dismiss) var dismiss
    @State var username: String = ""
    @State var messageFromAPI: String = ""
    @State var isSaveUserInfoSuccess: Bool = false
    @State var isSaveUserInfoFailed: Bool = false
    @State var phoneNumber = ""
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @State var isNavigateToLoginView: Bool = false
    var body: some View {
        ZStack {
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("basic_information")
                        .customFontMediumLocalize(size: 18)
                        .padding(.top)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("full_name")
                            .customFontMediumLocalize(size: 16)
                            .foregroundColor(Color(hex: "0A0019"))
                            .padding(.top)
                        InputationComponet(placeHolder: .constant("user_name"), textInput: $username, image: .constant("usernamePlaceholder"))
                        Text("phone_number")
                            .customFontMediumLocalize(size: 16)
                            .foregroundColor(Color(hex: "0A0019"))
                        InputationComponet(placeHolder: .constant("phone_number"), textInput: $phoneNumber, image: .constant("phone"))
                            .keyboardType(.numberPad)

                        ButtonComponent(action: {
                            if username.isEmpty {
                                isSaveUserInfoFailed = true
                                messageFromAPI = "please_fill_all_information"
                            } else {
                                authenticationViewModel.saveUserInfo(userName: username, phoneNumber: phoneNumber) { sussess, message in
                                    messageFromAPI = message
                                    if sussess {
                                        isSaveUserInfoSuccess = true
                                    } else {
                                        isSaveUserInfoFailed = true
                                    }
                                }
                            }
                        }, content: "_save").padding(.top)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image("backButton")
                        }
                    }
                }
            }
            SuccessAndFailedAlert(status: true, message: LocalizedStringKey(messageFromAPI), duration: 3, isPresented: $isSaveUserInfoSuccess)
                .onDisappear {
                    isNavigateToLoginView = true
                }
            SuccessAndFailedAlert(status: false, message: LocalizedStringKey(messageFromAPI), duration: 3, isPresented: $isSaveUserInfoFailed)
        }
        .fullScreenCover(isPresented: $isNavigateToLoginView) {
            AuthenticationView()
        }
    }
}

#Preview {
    AdditionalInformationView()
}
