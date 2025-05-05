//
//  ProfileDetailView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/1/25.
//

import SwiftUI

import Kingfisher
import SwiftUI

struct MyProfileView: View {
    @State private var selectedTab = "Personal"
    @ObservedObject var profileViewModel: ProfileViewModel
    @State var createAt = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/"
        NavigationView {
            VStack(spacing: 16) {
                ZStack {
                    if profileViewModel.userInfo?.payload.profileImage != "default.jpg" {
                        KFImage(URL(string: imageUrl + "\(profileViewModel.userInfo?.payload.profileImage ?? "")"))
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

                    // Lock Icon Overlay
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                        )
                        .offset(x: 35, y: 35)
                }
                VStack(alignment: .leading, spacing: 16) {
                    ProfileField(title: "full_name", value: profileViewModel.userInfo?.payload.fullName ?? "")
                    ProfileField(title: "email_address", value: profileViewModel.userInfo?.payload.email ?? "")
                    ProfileField(title: "phone_number", value: profileViewModel.userInfo?.payload.phoneNumber ?? "")
                    ProfileField(title: "created_at", value: createAt)
                }
                .padding()

                Spacer()
            }
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
                    Text("my_profile")
                        .customFontSemiBoldLocalize(size: 20)
                }
            }
            .onAppear {
                profileViewModel.getUserInfo { _, _ in
                    createAt = formatDateString(profileViewModel.userInfo?.payload.createdAt ?? "")
                    print("wefwe", profileViewModel.userInfo?.payload.createdAt ?? "")
                }
            }
        }
    }

    func formatDateString(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "en_US")
            outputFormatter.dateFormat = "d MMMM yyyy, h:mm a" // Example: 12 March 2025, 6:24 PM
            return outputFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
}

struct ProfileField: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(LocalizedStringKey(title))
                .customFontLocalize(size: 16)
                .foregroundColor(.gray)
            Text(value)
                .customFontKhmer(size: 16)
                .foregroundColor(.black)
            Divider()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
    }
}
