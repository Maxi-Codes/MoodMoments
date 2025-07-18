import Foundation

extension HomeViewModel {
    static func audioFileURL() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filename = "mood_" + UUID().uuidString + ".m4a"
        return docs.appendingPathComponent(filename)
    }
} 