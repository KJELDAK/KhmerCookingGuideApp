//
//  Settings.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 21/4/25.
//

import Foundation

final class Settings {
    static let shared = Settings()
    private init() {}

    func formattedDate(from isoString: String) -> String {
        // Use DateFormatter for microseconds
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Adjust as needed

        guard let date = formatter.date(from: isoString) else {
            return "Invalid date"
        }

        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.monthSymbols[calendar.component(.month, from: date) - 1]
        let year = calendar.component(.year, from: date)

        let hour = calendar.component(.hour, from: date)
        let partOfDay: String
        switch hour {
        case 5 ..< 12:
            partOfDay = "morning"
        case 12 ..< 17:
            partOfDay = "afternoon"
        case 17 ..< 21:
            partOfDay = "evening"
        default:
            partOfDay = "night"
        }

        return "\(day) \(month) \(year) (\(partOfDay))"
    }
}
