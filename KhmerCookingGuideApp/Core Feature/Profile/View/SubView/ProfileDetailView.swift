//
//  ProfileDetailView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/1/25.
//

import SwiftUI

import SwiftUI
import Kingfisher
struct MyProfileView: View {
    @State private var selectedTab = "Personal"
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/"
        NavigationView {
            VStack(spacing: 16) {
                ZStack {
                    if profileViewModel.userInfo?.payload.profileImage != "default.jpg"{
                     
                        
                        KFImage(URL(string: imageUrl + "\(profileViewModel.userInfo?.payload.profileImage ?? "")"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    else{
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
                        ProfileField(title: "Full Name", value: profileViewModel.userInfo?.payload.fullName ?? "")
                        ProfileField(title: "Email Address", value: profileViewModel.userInfo?.payload.email ?? "")
                        ProfileField(title: "Gender", value: profileViewModel.userInfo?.payload.phoneNumber ?? "")
                        ProfileField(title: "Create At", value: profileViewModel.userInfo?.payload.createdAt ?? "")
                    }
                    .padding()
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.left")
                                               .font(.title2)
                                               .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("My Profile")
                        .customFontRobotoBold(size: 16)
                }
            }
            .onAppear{
                profileViewModel.getUserInfo { _, _ in
                    
                }
            }
        }
    }
}

struct ProfileField: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
                .foregroundColor(.black)
            Divider()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
    }
}
