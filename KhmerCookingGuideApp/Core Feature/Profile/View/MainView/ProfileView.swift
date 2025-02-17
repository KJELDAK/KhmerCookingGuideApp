//
//  ProfileView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/1/25.
//

import SwiftUI
import Kingfisher
struct ProfileView: View {
    @Binding var selectedTab: Int
    @StateObject var profileViewModel = ProfileViewModel()
    @State var isNavigateToMyProfileView: Bool = false
    @State var isLogout: Bool = false
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/"
        NavigationView {
            VStack(spacing: 20) {
                // Profile Section
                VStack(spacing: 10) {
                    // Profile Image
                    ZStack {
//                        Circle()
//                            .fill(Color.gray.opacity(0.3))
//                            .frame(width: 100, height: 100)
                        if profileViewModel.userInfo?.payload.profileImage != "default.jpg"{
                         
                            
                            KFImage(URL(string: imageUrl + "\(profileViewModel.userInfo?.payload.profileImage ?? "")"))
                          /*  Image(systemName: "person.circle.fill")*/ // Replace with actual image
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
                    
                    // Name & Title
                    Text(profileViewModel.userInfo?.payload.fullName ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack{
                        Text("Role:")
                        Text(profileViewModel.userInfo?.payload.role == "ROLE_ADMIN" ? "Admin" : "User")
                    }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                

                ButtonComponent(action: {
                    
                }, content: "Edit Profile")
                .padding(.horizontal)

                // Settings List
                VStack(spacing: 0) {
                    Button{
                        isNavigateToMyProfileView = true
                    }label: {
                        ProfileOptionRow(icon: "person", title: "My Profile")
                    }
                   
                    Button{
                        selectedTab = 3
                    }label: {
                        ProfileOptionRow(icon: "bookmark", title: "Favorites")
                    }
                   
                    ProfileOptionRow(icon: "doc.text", title: "Terms & Conditions")
                    Button{
                        
                    }label: {
                        ProfileOptionRow(icon: "translate", title: "Application Language")
                    }

                    Button{
                        isLogout = true
                        
                    }label: {
                        ProfileOptionRow(icon: "arrow.left.circle.fill", title: "Logout")
                    }
                    
                }
                .fullScreenCover(isPresented: $isLogout, content: {
                    AuthenticationView()
                })
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                Spacer()
                
            }            
            .padding(.top)
//            .background(Color(UIColor.systemGroupedBackground))
            .onAppear {
                profileViewModel.getUserInfo { success, message in
                    print(message)
                }
            }
        }
        .navigationDestination(isPresented: $isNavigateToMyProfileView, destination: {
            MyProfileView(profileViewModel: profileViewModel).navigationBarBackButtonHidden(true)
        })
    }
}

// A reusable row for the options
struct ProfileOptionRow: View {
    var icon: String
    var title: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "primary"))
                .frame(width: 25, height: 25)
            Text(title)
                .font(.body)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
    }
}

// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(selectedTab: .constant(0))
    }
}
