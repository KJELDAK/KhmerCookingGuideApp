//
//  EditProfileView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 28/4/25.
//

import Kingfisher
import PhotosUI
import SwiftUI

struct EditProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var isShowSuccessAlert: Bool = false
    @State private var isShowErrorAlert: Bool = false
    @State private var isLoadingWhenUploadImage = false

    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/"

        ZStack {
            NavigationView {
                VStack {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Your photo picker
                            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                                ZStack {
                                    if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    } else {
                                        if profileViewModel.userInfo?.payload.profileImage != "default.jpg" {
                                            KFImage(URL(string: imageUrl + (profileViewModel.userInfo?.payload.profileImage ?? "")))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        } else {
                                            Image("defaultPFMale")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        }
                                    }

                                    // Edit Icon
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(systemName: "pencil")
                                                .foregroundColor(.white)
                                        )
                                        .offset(x: 35, y: 35)
                                }
                            }
                            .frame(height: 100)

                            // Editable Fields
                            VStack(alignment: .leading, spacing: 16) {
                                Text("full_name")
                                    .customFontMediumLocalize(size: 12)
                                    .foregroundColor(Color(hex: "00000"))

                                InputTextComponent(textInput: $fullName, placeHolder: "enter_full_name")

                                Text("_gender")
                                    .customFontMediumLocalize(size: 12)
                                    .foregroundColor(Color(hex: "00000"))

                                InputTextComponent(textInput: $phoneNumber, placeHolder: "enter_phone_number")
                            }
                            .padding()

                            Spacer(minLength: 100) // Add a little space at the bottom if you want
                        }
                    }.scrollIndicators(.hidden)

                    // Button at bottom
                    ButtonComponent(action: {
                        saveProfile(fullName: fullName, phoneNumber: phoneNumber)
                    }, content: LocalizedStringKey("save_changes"))
                        .padding()
                        .background(Color.white) // Optional: background to avoid transparency
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("edit_profile")
                            .customFontSemiBoldLocalize(size: 20)
                    }
                }
                .onAppear {
                    if let payload = profileViewModel.userInfo?.payload {
                        fullName = payload.fullName
                        phoneNumber = payload.phoneNumber
//                        imageUrl = payload.profileImage
                    }
                }
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            // Optionally, uploadProfileImage(data) here
                        }
                    }
                }
            }
            if profileViewModel.isLoadingWhenUpdate {
                LoadingComponent()
            }
            SuccessAndFailedAlert(status: true, message: "update_profile_success", duration: 3, isPresented: $isShowSuccessAlert)
                .onDisappear {
                    dismiss()
                }
            SuccessAndFailedAlert(status: false, message: "update_profile_failed", duration: 3, isPresented: $isShowErrorAlert)
        }
    }

    private func saveProfile(fullName: String, phoneNumber: String) {
        if let imageData = selectedImageData {
            // User selected a new image
            FileUploader.shared.uploadFiles(imageDataArray: [imageData]) { success, message in
                if success {
                    if let uploadedFileName = FileUploader.shared.image.first {
                        let fileName = (uploadedFileName as NSString).lastPathComponent

                        profileViewModel.updateUserProfile(
                            profileImage: fileName,
                            fullName: fullName,
                            phoneNumber: phoneNumber
                        ) { success, _ in
                            if success {
                                isShowSuccessAlert = true
                            } else {
                                isShowErrorAlert = true
                            }
                        }
                    } else {
                        print("❌ No uploaded filename found.")
                        isShowErrorAlert = true
                    }
                } else {
                    print("❌ Upload failed: \(message)")
                    isShowErrorAlert = true
                }
            }
        } else {
            // User did NOT select a new image — use existing
            if let existingFileName = profileViewModel.userInfo?.payload.profileImage {
                let fileName = (existingFileName as NSString).lastPathComponent

                profileViewModel.updateUserProfile(
                    profileImage: fileName,
                    fullName: fullName,
                    phoneNumber: phoneNumber
                ) { success, _ in
                    if success {
                        isShowSuccessAlert = true
                    } else {
                        isShowErrorAlert = true
                    }
                }
            } else {
                print("❌ No existing profile image found.")
                isShowErrorAlert = true
            }
        }
    }

    // MARK: - Edit Field View (Same style as ProfileField but editable)

    struct EditProfileField: View {
        var title: String
        @Binding var text: String

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField(title, text: $text)
                    .font(.body)
                    .foregroundColor(.black)
                Divider()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 4)
        }
    }
}
