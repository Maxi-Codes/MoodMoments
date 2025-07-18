import Foundation

extension AnalyseViewModel {
    struct DayStat: Identifiable {
        let id = UUID()
        let date: Date
        let averageMood: Double
    }
} 