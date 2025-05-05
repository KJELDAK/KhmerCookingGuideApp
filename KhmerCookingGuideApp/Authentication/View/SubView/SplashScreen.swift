//
//  SplashScreen.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/12/24.
//
import SwiftUI

// struct SplashScreen: View {
//    @State private var isActive = false
//
//    var body: some View {
//        ZStack {
//            // Main Content
//            if isActive {
//                withAnimation(.easeInOut){
//                    AuthenticationView()
//                }
//            } else {
//                // Splash Screen Content
//                ZStack {
//                    VStack {
//                        Image("logo")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 180, height: 180)
//
//                    }
//                }
//            }
//        }
//        .onAppear {
//
//            // Timer to simulate launch delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                withAnimation {
//                    isActive = true
//                }
//            }
//        }
//    }
// }
struct SplashScreen: View {
    @State private var isActive = false
    @State private var isLoggedIn = false
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @StateObject var profileViewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if isActive {
                    if isLoggedIn {
                        ContentView()

                    } else {
                        AuthenticationView()
                    }
                } else {
                    VStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .ignoresSafeArea()
                }
            }
            .onAppear {
                authenticationViewModel.autoLogin { success, message in
                    if success {
                        self.isLoggedIn = true
                        profileViewModel.getUserInfo { _, _ in
                            print("User info loaded after auto-login")
                        }
                    } else {
                        self.isLoggedIn = false
                        print("Auto-login failed: \(message ?? "")")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}
