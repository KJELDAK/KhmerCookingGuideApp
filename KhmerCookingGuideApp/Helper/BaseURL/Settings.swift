import Foundation

final class Settings {
    // MARK: - Shared Instance
    static let shared = Settings()
    
    // MARK: - Private Initializer
    private init() {}

    // MARK: - Date Formatting
    func formattedDate(from isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: isoString) else {
            return "Invalid date"
        }

        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.monthSymbols[calendar.component(.month, from: date) - 1]
        let year = calendar.component(.year, from: date)
        
        let hour = calendar.component(.hour, from: date)
        let partOfDay: String
        switch hour {
        case 5..<12:
            partOfDay = "morning"
        case 12..<17:
            partOfDay = "afternoon"
        case 17..<21:
            partOfDay = "evening"
        default:
            partOfDay = "night"
        }

        return "\(day) \(month) \(year) (\(partOfDay))"
    }
}
