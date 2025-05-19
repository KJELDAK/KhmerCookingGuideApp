//
//  ProfileView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/1/25.
//

import Kingfisher
import SwiftUI

struct ProfileView: View {
    @StateObject var authenticationViewModel = AuthenticationViewModel() // <-- Add this
    @Binding var selectedTab: Int
    @StateObject var profileViewModel = ProfileViewModel()
    @State var isNavigateToMyProfileView: Bool = false

    @State var isShowLanguagePicker: Bool = false
    @State var isNavigateToTermAndConditionView: Bool = false
    @EnvironmentObject var languageManager: LanguageManager
    @State var isNavigateToEditProfileView: Bool = false
    @Binding var isShowLogoutAlert: Bool
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/"
        NavigationView {
            VStack(spacing: 20) {
                // Profile Section
                VStack(spacing: 10) {
                    // Profile Image
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

                    // Name & Title
                    Text(profileViewModel.userInfo?.payload.fullName ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)

                    HStack {
                        Text("_role")
                        Text(profileViewModel.userInfo?.payload.role == "ROLE_ADMIN" ? "Admin" : "User")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }

                ButtonComponent(action: {
                    isNavigateToEditProfileView = true
                }, content: "edit_profile")
                    .padding(.horizontal)

                // Settings List
                VStack(spacing: 0) {
                    Button {
                        isNavigateToMyProfileView = true
                    } label: {
                        ProfileOptionRow(icon: "person", title: "my_profile")
                    }

                    Button {
                        selectedTab = 3
                    } label: {
                        ProfileOptionRow(icon: "bookmark", title: "favorites")
                    }

                    Button {
                        isNavigateToTermAndConditionView = true
                    } label: {
                        ProfileOptionRow(icon: "doc.text", title: "terms_and_conditions")
                    }

                    Button {
                        isShowLanguagePicker = true
                    } label: {
                        ProfileOptionRow(icon: "translate", title: "application_language")
                    }

                    Button {
                        isShowLogoutAlert = true

                    } label: {
                        ProfileOptionRow(icon: "arrow.left.circle.fill", title: "logout")
                    }
                }
                .sheet(isPresented: $isShowLanguagePicker) {
                    LanguageSelectionView(showLanguageSheet: $isShowLanguagePicker)
                        .environmentObject(languageManager) // passed from App level
                }

                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)

                Spacer()
            }
            .overlay(content: {})
            .navigationDestination(isPresented: $isNavigateToTermAndConditionView, destination: {
                TermsAndConditionsView().navigationBarBackButtonHidden(true)
            })
            .padding(.top)
//            .background(Color(UIColor.systemGroupedBackground))
            .onAppear {
                profileViewModel.getUserInfo { _, message in
                    print(message)
                }
            }
        }
        .navigationDestination(isPresented: $isNavigateToMyProfileView, destination: {
            MyProfileView(profileViewModel: profileViewModel).navigationBarBackButtonHidden(true)
        })
        .navigationDestination(isPresented: $isNavigateToEditProfileView) {
            EditProfileView(profileViewModel: profileViewModel)
                .navigationBarBackButtonHidden(true)
        }
    }
}

// A reusable row for the options
struct ProfileOptionRow: View {
    var icon: String
    var title: LocalizedStringKey

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "primary"))
                .frame(width: 25, height: 25)
            Text(title)
                .customFontLocalize(size: 16)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
    }
}

class LanguageManager: ObservableObject {
    @Published var lang: String {
        didSet {
            UserDefaults.standard.set(lang, forKey: "lang")
            // Trigger a refresh on language change
        }
    }

    var displayName: String {
        switch lang {
        case "km": return "_khmer"
        case "en": return "_english"
        default: return "_english" // Default language
        }
    }

    init() {
        lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    }

    func setLanguage(displayName: String) {
        // Set language based on full name (case insensitive)
        switch displayName.lowercased() {
        case "_khmer": lang = "km"
        default: lang = "en" // Default language
        }
    }
}
