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
    @State var dateOfBirth = ""
    @State var gender = ""
    @State var messageFromAPI: String = ""
    @State var isSaveUserInfoSuccess : Bool = false
    @State var isSaveUserInfoFailed : Bool = false
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @State var isNavigateToLoginView: Bool = false
    var body: some View {
        ZStack{
            NavigationView {
                VStack(alignment: .leading, spacing: 16){
                    Text("Basic Information")
                        .customFontRobotoBold(size: 18)
                        .padding(.top)
                    VStack(alignment: .leading, spacing: 16){
                        Text("Username")
                            .customFontMedium(size: 16)
                            .foregroundColor(Color(hex: "0A0019"))
                            .padding(.top)
                        InputationComponet(placeHolder: .constant("User Name"), textInput: $username, image: .constant("usernamePlaceholder"))
                        Text("Date of birth")
                            .customFontMedium(size: 16)
                            .foregroundColor(Color(hex: "0A0019"))
                        DateInputComponent(placeHolder: .constant("Date of birth"), image: .constant("calendar"), requestDateOfBirth: $dateOfBirth)
                        Text("Username")
                            .customFontMedium(size: 16)
                            .foregroundColor(Color(hex: "0A0019"))
                        GenderPickerComponent(placeHolder: .constant("Gender"),  image: .constant("gender"), requestGender: $gender)
                        ButtonComponent(action: {
                            print(gender, dateOfBirth, username)
                            authenticationViewModel.saveUserInfo(userName: username, dateOfBirth: dateOfBirth, gender: gender) { sussess, message in
                                messageFromAPI = message
                                if sussess{
                                    isSaveUserInfoSuccess = true
                                }
                                else {
                                    isSaveUserInfoFailed = true
                                }
                            
                            }
                        }, content: "Save").padding(.top)
                        
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal)
                    .toolbar {
                        ToolbarItem( placement: .navigationBarLeading) {
                            Button{
                                dismiss()
                            }label: {
                                Image("backButton")
                            }
                        }
                    }
            }
            SuccessAndFailedAlert(status: true, message: messageFromAPI, duration: 3, isPresented: $isSaveUserInfoSuccess)
                .onDisappear{
                    isNavigateToLoginView = true
                }
            SuccessAndFailedAlert(status: false, message: messageFromAPI, duration: 3, isPresented: $isSaveUserInfoFailed)
            
        }
        .fullScreenCover(isPresented: $isNavigateToLoginView) {
            AuthenticationView()
        }
        
    }
}

#Preview {
    AdditionalInformationView()
}
