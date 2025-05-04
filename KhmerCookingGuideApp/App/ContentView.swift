////
////  ContentView.swift
////  KhmerCookingGuideApp
////
////  Created by Sok Reaksa on 12/12/24.
////
//
//import SwiftUI
//
//
//struct ContentView: View {
//    @State var selectedTab: Int = 0
//    @State var isPresented: Bool = false
//   
//    var body: some View {
//        NavigationControllerWrapper{
//            ZStack{
//                Spacer().fullScreenCover(isPresented: $isPresented) {
//                    PostFoodRecipeView(isSheetPresent: $isPresented, selectedTab: $selectedTab)
//                }
//                CustomTabBar {
//                    TabView(selection: $selectedTab) {
//                        //MARK: - First Tab
//                        VStack{
//                            HomeScreenView(selectedTab: $selectedTab)
//                        }
//                            .tag(0)
//                            .tabItem {
//                                Label("Home", image: selectedTab == 0 ? "activeHome" : "home")
//                            }
//
//                        //MARK: - Second Tab
//                        VStack{
//                            RecipeView()
//                        }
//                            .tag(1)
//                            .tabItem {
//                                Label("Recipe", image: selectedTab == 1 ? "activeRecipe" : "recipe")
//                            }
//                        //MARK: - Third Tab
//                        Text("")
//                            .tag(2)
//                        //MARK: - fourth Tab
//                        VStack{
//                            FavoritesView()
//                        }
//                            .tag(3)
//                            .tabItem {
//                                Label("Favorite", image: selectedTab == 3 ? "activeFavorite" : "favorite")
//                            }
//                        //MARK: - Five Tab
//                        VStack{
//                            ProfileView(selectedTab: $selectedTab)
//                        }
//                            .tag(4)
//                            .tabItem {
//                                Label("Profile", image: selectedTab == 4 ? "activeProfile" : "profile")
//                            }
//                    }
//                    .accentColor(Color(hex: "FF0000"))
//                    .onChange(of: selectedTab) { newValue in
//                        if selectedTab == 2 {
//                            isPresented = true
//                        }
//                    }
//                }
//            }
//            .onAppear{
//                print("token",HeaderToken.shared.token)
//                
//            }
//        }
//    }
//}
//
//struct CustomTabBar<Content: View>: View {
//    let content: Content
//
//    init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//        UITabBar.appearance().backgroundColor = UIColor.systemBackground // Default background color
//    }
//
//    var body: some View {
//        ZStack {
//            content
//            CustomTabBarOverlay()
//        }
//    }
//}
//
//struct CustomTabBarOverlay: View {
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    
//                    // First Tab
//                    Spacer()
//
//                    // Second Tab: Add Circle Background
//                    Button{
//                        
//                    }label: {
//                        Circle()
//                            .fill(Color(hex: "FF0000"))
//                            .frame(width: 50, height: 50)
//                            .overlay(
//                                Text("+")
//                                    .font(.system(size: 24))
//                                    .foregroundColor(.white)
//                            )
////                            .offset(y: -10)
//                    }
////                    .hidden()
////                        .disabled(true)
//
//                    Spacer()
//
//                    Spacer() // Additional spacing for other tabs
//                }
//            }
//            .allowsHitTesting(false) // Prevent the custom view from blocking taps
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
//
//  ContentView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 12/12/24.
//

import SwiftUI
struct ContentView: View {
    @State var selectedTab: Int = 0
    @State var isPresented: Bool = false
    @State var isShowLogoutAlert : Bool = false
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @State var isLogout: Bool = false
    var body: some View {
        ZStack{
            NavigationControllerWrapper{
                if HeaderToken.shared.role == "ROLE_ADMIN"{
                    ZStack{
                        Spacer().fullScreenCover(isPresented: $isPresented) {
                            PostFoodRecipeView(isSheetPresent: $isPresented, selectedTab: $selectedTab)
                        }
                        CustomTabBar {
                            TabView(selection: $selectedTab) {
                                //MARK: - First Tab
                                VStack{
                                    HomeScreenView(selectedTab: $selectedTab)
                                }
                                .tag(0)
                                .tabItem {
                                    Label("Home", image: selectedTab == 0 ? "activeHome" : "home")
                                }
                                
                                //MARK: - Second Tab
                                VStack{
                                    RecipeView()
                                }
                                .tag(1)
                                .tabItem {
                                    Label("Recipe", image: selectedTab == 1 ? "activeRecipe" : "recipe")
                                }
                                //MARK: - Third Tab
                                Text("")
                                    .tag(2)
                                //MARK: - fourth Tab
                                VStack{
                                    FavoritesView(selectedTab: $selectedTab)
                                }
                                .tag(3)
                                .tabItem {
                                    Label("Favorite", image: selectedTab == 3 ? "activeFavorite" : "favorite")
                                }
                                //MARK: - Five Tab
                                VStack{
                                    ProfileView(selectedTab: $selectedTab, isShowLogoutAlert: $isShowLogoutAlert)
                                }
                                .tag(4)
                                .tabItem {
                                    Label("Profile", image: selectedTab == 4 ? "activeProfile" : "profile")
                                }
                            }
                            .accentColor(Color(hex: "FF0000"))
                            .onChange(of: selectedTab) {
                                if selectedTab == 2 {
                                    isPresented = true
                                }
                            }
                        }
                        
                    }
                    .onAppear{
                        print("token",HeaderToken.shared.token)
                        print("userRole",HeaderToken.shared.role)
                        
                    }
                    
                }
                else{
                    ZStack{
                        Spacer().fullScreenCover(isPresented: $isPresented) {
                            PostFoodRecipeView(isSheetPresent: $isPresented, selectedTab: $selectedTab)
                        }
                        CustomTabBar {
                            TabView(selection: $selectedTab) {
                                //MARK: - First Tab
                                VStack{
                                    HomeScreenView( selectedTab: $selectedTab)
                                }
                                .tag(0)
                                .tabItem {
                                    Label("Home", image: selectedTab == 0 ? "activeHome" : "home")
                                }
                                
                                //MARK: - Second Tab
                                VStack{
                                    RecipeView()
                                }
                                .tag(1)
                                .tabItem {
                                    Label("Recipe", image: selectedTab == 1 ? "activeRecipe" : "recipe")
                                }
                                //MARK: - Third Tab
                                //                            Text("")
                                //                                .tag(2)
                                //MARK: - fourth Tab
                                VStack{
                                    FavoritesView(selectedTab: $selectedTab)
                                }
                                .tag(3)
                                .tabItem {
                                    Label("Favorite", image: selectedTab == 3 ? "activeFavorite" : "favorite")
                                }
                                //MARK: - Five Tab
                                VStack{
                                    ProfileView(selectedTab: $selectedTab, isShowLogoutAlert: $isShowLogoutAlert)
                                }
                                .tag(4)
                                .tabItem {
                                    Label("Profile", image: selectedTab == 4 ? "activeProfile" : "profile")
                                }
                            }
                            .accentColor(Color(hex: "FF0000"))
                            .onChange(of: selectedTab) { newValue in
                                if selectedTab == 2 {
                                    isPresented = true
                                }
                            }
                        }
                        
                        
                    }
                    .onAppear{
                        print("token",HeaderToken.shared.token)
                        
                    }
                    
                }
            }
            if isShowLogoutAlert{
                DeleteView(status: false, title: "logout_title", message: "logout_message") {
                    authenticationViewModel.logout()
                    isLogout = true
                } cancelAction: {
                    isShowLogoutAlert = false
                    isLogout = false
                }
            }
        }
        .fullScreenCover(isPresented: $isLogout, content: {
            AuthenticationView()
        })
        
    }
}

struct CustomTabBar<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        UITabBar.appearance().backgroundColor = UIColor.systemBackground // Default background color
    }
    
    var body: some View {
        ZStack {
            content
            CustomTabBarOverlay()
        }
    }
}

struct CustomTabBarOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    // First Tab
                    Spacer()
                    
                    // Second Tab: Add Circle Background
                    if HeaderToken.shared.role == "ROLE_ADMIN"{
                        Button{
                            
                        }label: {
                            Circle()
                                .fill(Color(hex: "FF0000"))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text("+")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                )
                            //                            .offset(y: -10)
                        }
                    }
                    else{}
                    //                    .hidden()
                    //                        .disabled(true)
                    
                    Spacer()
                    
                    Spacer() // Additional spacing for other tabs
                }
            }
            .allowsHitTesting(false) // Prevent the custom view from blocking taps
        }
    }
}

#Preview {
    ContentView()
}
