//
//  KhmerCookingGuideAppApp.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/12/24.
//

import SwiftUI
import SwiftData
import IQKeyboardManagerSwift
@main
struct KhmerCookingGuideAppApp: App {
    @State var lang: String = "en"
    @StateObject var recipeVM = RecipeViewModel()

    // Linking the AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
 
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont(name: "Roboto-Bold", size: 20) ?? UIFont.systemFont(ofSize: 15)
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        let unselectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Inter_18pt-Regular", size: 10) ?? UIFont.systemFont(ofSize: 12),
        ]
        // Change the font for selected tab bar items
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Inter_18pt-Regular", size: 10) ?? UIFont.systemFont(ofSize: 12),
        ]
        // Apply the attributes to UITabBarItem for both selected and unselected states
        UITabBarItem.appearance().setTitleTextAttributes(unselectedAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
        //set color for tabar
        UITabBar.appearance().unselectedItemTintColor = UIColor(hex: "797979")
//        
//        // MARK: - disable keyboard when click any where
//        IQKeyboardManager.shared.isEnabled = true
//        IQKeyboardManager.shared.resignOnTouchOutside = true

//
//        // Customize TabBar background color
//        let appearance2 = UITabBarAppearance()
//        appearance2.configureWithOpaqueBackground()
//        appearance2.backgroundColor = UIColor.systemGray6 // Your custom color
//        UITabBar.appearance().standardAppearance = appearance2
//        UITabBar.appearance().scrollEdgeAppearance = appearance2
    }

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environment(\.locale, .init(identifier: lang))
                .environmentObject(recipeVM)

//            OTPView()
        }
        .modelContainer(sharedModelContainer)
    }
}
