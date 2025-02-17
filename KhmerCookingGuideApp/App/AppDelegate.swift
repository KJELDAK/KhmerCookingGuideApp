//
//  AppDelegate.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 15/12/24.
//
import UIKit
import IQKeyboardManagerSwift

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Enable IQKeyboardManager
        IQKeyboardManager.shared.isEnabled = true
        
        // Allow tapping outside to dismiss the keyboard
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        return true
    }
}

