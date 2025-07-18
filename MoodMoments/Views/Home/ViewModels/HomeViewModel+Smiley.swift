import SwiftUI

extension HomeViewModel {
    func smiley(for mood: Int) -> String { MoodEntry(mood: mood).smiley }
    func smileyColor(for mood: Int) -> Color { MoodEntry(mood: mood).smileyColor }
    func smileyLabel(for mood: Int) -> String { MoodEntry(mood: mood).moodLabel }
} 