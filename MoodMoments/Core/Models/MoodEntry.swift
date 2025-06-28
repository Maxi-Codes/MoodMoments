//  MoodEntry.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
//

import Foundation
import SwiftData

/// Persistentes Datenmodell für einen Stimmungseintrag
@Model
final class MoodEntry {
    var id: UUID
    var mood: Int          // 1–5
    var date: Date
    var audioFilePath: String?

    init(mood: Int, date: Date = .now, audioFilePath: String? = nil) {
        self.id = UUID()
        self.mood = mood
        self.date = date
        self.audioFilePath = audioFilePath
    }

    // MARK: – Convenience
    var smiley: String {
        switch mood {
        case 1: return "face.dashed"             // sehr schlecht
        case 2: return "face.smiling.inverse"    // schlecht
        case 3: return "face.smiling"            // neutral
        case 4: return "face.smiling.fill"       // gut
        case 5: return "face.smiling"            // sehr gut (Symbol doppelt, aber andere Farbe möglich)
        default: return "questionmark"
        }
    }

    var moodLabel: String {
        switch mood {
        case 1: return "Sehr schlecht"
        case 2: return "Schlecht"
        case 3: return "Neutral"
        case 4: return "Gut"
        case 5: return "Sehr gut"
        default: return "Unbekannt"
        }
    }
}
