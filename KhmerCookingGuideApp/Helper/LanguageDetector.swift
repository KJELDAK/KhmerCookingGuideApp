//
//  LanguageDetector.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 21/4/25.
//

final class LanguageDetector {
    static let shared = LanguageDetector()

    private init() {}

    func isKhmerText(_ text: String) -> Bool {
        for scalar in text.unicodeScalars {
            if scalar.value >= 0x1780 && scalar.value <= 0x17FF {
                return true
            }
        }
        return false
    }
}
