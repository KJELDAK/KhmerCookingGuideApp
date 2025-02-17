//
//  SplashScreen.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/12/24.
//
import SwiftUI
struct SplashScreen: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            // Main Content
            if isActive {
                withAnimation(.easeInOut){
                    AuthenticationView()
                }
            } else {
                // Splash Screen Content
                ZStack {
                    VStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                     
                    }
                }
            }
        }
        .onAppear {
           
            // Timer to simulate launch delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
