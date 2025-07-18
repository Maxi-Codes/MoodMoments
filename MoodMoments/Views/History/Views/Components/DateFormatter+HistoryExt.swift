import Foundation

extension DateFormatter {
    static let germanMonthAndYear: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "de_DE")
        df.setLocalizedDateFormatFromTemplate("LLLL yyyy")
        return df
    }()
    static let germanLongDate: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "de_DE")
        df.dateStyle = .long
        df.timeStyle = .none
        return df
    }()
}

extension TimeInterval {
    var timeString: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
} 