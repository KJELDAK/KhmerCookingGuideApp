//
//  Color.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/12/24.
//

import SwiftUI

extension Color {
    
    // Initializes a Color from a hex string.
    init(hex: String) {
        var hex = Color.resolvePredefinedColor(hex: hex)
         hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        
        switch hex.count {
        case 3:
            // Handle shorthand notation (e.g. "123" => RGB)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            // Handle standard hex format (e.g. "RRGGBB")
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            // Handle hex format with alpha (e.g. "AARRGGBB")
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            // Default to fully opaque black
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // Resolves predefined color names like "primary" or "secondary".
    private static func resolvePredefinedColor(hex: String) -> String {
        switch hex.lowercased() {
        case "primary":
            return "FF0000" // Define your primary color hex
        case "secondary":
            return "#EC221F" // Define your secondary color hex
        default:
            return hex // Return the original hex if no predefined match
        }
    }
}
import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        if hexString.count != 6 {
            self.init(white: 0.5, alpha: 1.0) // Default color if hex string is invalid
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
