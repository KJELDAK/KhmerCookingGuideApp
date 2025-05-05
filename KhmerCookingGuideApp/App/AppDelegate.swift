//
//  AppDelegate.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 15/12/24. j
//
import IQKeyboardManagerSwift
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Enable IQKeyboardManager
        IQKeyboardManager.shared.isEnabled = true

        // Allow tapping outside to dismiss the keyboard
        IQKeyboardManager.shared.resignOnTouchOutside = true

        return true
    }
}
